import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/provider/ThemeProvider.dart';
import 'package:film_atlasi/features/movie/screens/SettingsPage.dart';
import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:film_atlasi/features/movie/screens/FilmAsistani.dart/widget/MovieIntroPage.dart';
import 'package:film_atlasi/features/user/widgets/EditProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // AppConstants instance
    final appConstants = AppConstants(context);

    // ThemeProvider'dan tema modunu al
    var themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Kullanıcı bilgilerini al
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? "Anan";
    final String email = user?.email ?? "Product Designer";
    final String? photoUrl = user?.photoURL;

    return Drawer(
      width: MediaQuery.of(context).size.width *
          0.75, // Ekran genişliğinin %75'i kadar
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            // Profil Bilgisi
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange,
                    backgroundImage:
                        photoUrl != null ? NetworkImage(photoUrl) : null,
                    child: photoUrl == null
                        ? Icon(Icons.person, size: 30, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: appConstants.titleTextStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: appConstants.subtitleTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // Menü Öğeleri
            _buildMenuItem(
              context: context,
              icon: Icons.dashboard_outlined,
              title: 'Ansayfa',
              onTap: () {
                Navigator.pop(context);
                // Dashboard sayfasına yönlendirme eklenebilir
              },
              isDarkMode: isDarkMode,
            ),

            _buildMenuItem(
              context: context,
              icon: Icons.person_outline,
              title: 'Profili düzenle',
              onTap: () => _editProfile(context),
              isDarkMode: isDarkMode,
            ),

            // Film Asistanı
            _buildMenuItem(
              context: context,
              icon: Icons.movie_outlined,
              title: 'Film Asistanı',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieIntroPage()),
                );
              },
              isDarkMode: isDarkMode,
            ),

            // Film Ara
            _buildMenuItem(
              context: context,
              icon: Icons.search_outlined,
              title: 'Film Ara',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const FilmAraWidget(mode: "film_incele")),
                );
              },
              isDarkMode: isDarkMode,
            ),

            // Listelerim
            _buildMenuItem(
              context: context,
              icon: Icons.list_alt_outlined,
              title: 'Film Listelerim',
              onTap: () {
                Navigator.pop(context);
                _showMyLists(context);
              },
              isDarkMode: isDarkMode,
            ),

            // Tema Değiştirme Switch
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.dark_mode_outlined,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Dark Tema',
                        style: appConstants.bodyTextStyle,
                      ),
                    ],
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                    activeColor: Colors.red,
                  ),
                ],
              ),
            ),

            // Ayarlar Menüsü
            _buildMenuItem(
              context: context,
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                // Ayarlar sayfasına yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
              isDarkMode: isDarkMode,
            ),

            const Spacer(),

            // Çıkış Yap Butonu
            _buildMenuItem(
              context: context,
              icon: Icons.logout_outlined,
              title: 'Çıkış Yap',
              onTap: () => _logout(context),
              isDarkMode: isDarkMode,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDarkMode,
    bool isDestructive = false,
  }) {
    final appConstants = AppConstants(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? Colors.red
            : (isDarkMode ? Colors.white : Colors.black),
      ),
      title: Text(
        title,
        style: isDestructive
            ? appConstants.accentTextStyle
            : appConstants.bodyTextStyle,
      ),
      onTap: onTap,
    );
  }

  void _editProfile(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfilePage(
              userMap: userData,
              userId: user.uid,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kullanıcı verisi bulunamadı.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Giriş yapmış kullanıcı bulunamadı!")),
      );
    }
  }

  Future<void> _showMyLists(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen önce giriş yapın")),
      );
      return;
    }

    try {
      QuerySnapshot listSnapshot = await FirebaseFirestore.instance
          .collection('film_listeleri')
          .where('userId', isEqualTo: user.uid)
          .get();

      if (listSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Henüz bir film listeniz bulunmuyor")),
        );
        return;
      }

      // Daha sonra liste görüntüleme sayfasına yönlendirme yapılabilir
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const UserListsPage()),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Listeler yüklenirken hata oluştu: $e")),
      );
    }
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      // İlgili sayfalara yönlendirme
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Çıkış sırasında hata oluştu: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Çıkış yaparken bir hata oluştu!")),
      );
    }
  }
}
