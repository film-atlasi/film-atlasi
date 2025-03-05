
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/user/widgets/EditProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isSettingsExpanded = false; // 🔥 Ayarlar açık/kapalı kontrolü

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppConstants.primaryColor,
            ),
            child: Text(
              'Menü',
              style: TextStyle(color: AppConstants.textColor, fontSize: 24),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Ayarlar',
            onTap: () {
              setState(() {
                _isSettingsExpanded = !_isSettingsExpanded; // 🔥 Aç/kapa
              });
            },
          ),
          if (_isSettingsExpanded) // 🔥 Eğer açık ise "Profil Düzenle" seçeneğini göster
            Padding(
              padding: const EdgeInsets.only(left: 40.0), // İçeri kaydırma
              child: _buildDrawerItem(
                fontSize: 12,
                icon: Icons.person,
                title: 'Profil Düzenle',
                onTap: () async {
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    DocumentSnapshot userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get();

                    if (userDoc.exists) {
                      Map<String, dynamic> userData =
                          userDoc.data() as Map<String, dynamic>;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            userMap:
                                userData, // ✅ Firestore'dan alınan verileri gönderiyoruz
                            userId: user
                                .uid, // ✅ Kullanıcının UID'sini gönderiyoruz
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Kullanıcı verileri bulunamadı.")),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Giriş yapmış kullanıcı bulunamadı!")),
                    );
                  }
                },
              ),
            ),
          _buildDrawerItem(
            icon: Icons.lock,
            title: 'Gizlilik',
            onTap: () {
              // Gizlilik işlemi
            },
          ),
          _buildDrawerItem(
            icon: Icons.palette,
            title: 'Tema',
            onTap: () {
              // Tema işlemi
            },
          ),
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            title: 'Çıkış Yap',
            onTap: () async {
              await FirebaseAuth.instance.signOut(); // Çıkış yap
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/giris',
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(
      {required IconData icon,
      required String title,
      double fontSize = 18,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(fontSize: fontSize)),
      onTap: onTap,
    );
  }
}
