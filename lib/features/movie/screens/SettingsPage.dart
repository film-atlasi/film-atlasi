import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/provider/ThemeProvider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Türkçe';
  User? currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool _isLoading = true;

  final List<String> _availableLanguages = ['Türkçe', 'English'];

  @override
  void initState() {
    super.initState();
    _fetchUserSettings();
  }

  Future<void> _fetchUserSettings() async {
    setState(() {
      _isLoading = true;
    });

    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
            _notificationsEnabled = userData?['notifications_enabled'] ?? true;
            _selectedLanguage = userData?['language'] ?? 'Türkçe';
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        print("Ayarlar yüklenirken hata: $e");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .update({
          'notifications_enabled': _notificationsEnabled,
          'language': _selectedLanguage,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ayarlar kaydedildi")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ayarlar kaydedilirken hata: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final appConstants = AppConstants(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: ListView(
        children: [
          // Uygulama Ayarları Bölümü
          _buildSectionHeader(context, "Uygulama Ayarları"),
          SwitchListTile(
            title: Text("Bildirimler", style: appConstants.bodyTextStyle),
            subtitle: Text(
              "Yeni film önerileri ve aktiviteler hakkında bildirim al",
              style: appConstants.subtitleTextStyle,
            ),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          ListTile(
            title: Text("Dil", style: appConstants.bodyTextStyle),
            subtitle:
                Text(_selectedLanguage, style: appConstants.subtitleTextStyle),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title:
                        Text("Dil Seçin", style: appConstants.titleTextStyle),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _availableLanguages.length,
                        itemBuilder: (context, index) {
                          final language = _availableLanguages[index];
                          return ListTile(
                            title: Text(language,
                                style: appConstants.bodyTextStyle),
                            trailing: language == _selectedLanguage
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedLanguage = language;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text("Tema", style: appConstants.bodyTextStyle),
            subtitle: Text(isDarkMode ? "Koyu Tema" : "Açık Tema",
                style: appConstants.subtitleTextStyle),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ),

          // Hesap Bölümü
          _buildSectionHeader(context, "Hesap Ayarları"),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Gizlilik Ayarları"),
            onTap: () {
              // Gizlilik Ayarları sayfasına yönlendirme
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Çıkış Yap"),
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Çıkış yaparken hata: $e")),
                );
              }
            },
          ),

          // İçerik Tercihleri
          _buildSectionHeader(context, "İçerik Tercihleri"),
          ListTile(
            leading: const Icon(Icons.movie_filter_outlined),
            title: const Text("Favori Film Türleri"),
            subtitle: const Text("İlgilendiğiniz film türlerini belirleyin"),
            onTap: () {
              // Film türleri seçim sayfasına yönlendirme
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Favori Yönetmenler ve Oyuncular"),
            subtitle: const Text("Takip etmek istediğiniz kişileri seçin"),
            onTap: () {
              // Favori kişiler seçim sayfasına yönlendirme
            },
          ),

          // Uygulama Hakkında
          _buildSectionHeader(context, "Uygulama Hakkında"),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Sürüm Bilgisi"),
            subtitle: const Text("1.0.0"),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Yardım ve Destek"),
            onTap: () {
              // Yardım sayfasına yönlendirme
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          inherit: true,
        ),
      ),
    );
  }
}
