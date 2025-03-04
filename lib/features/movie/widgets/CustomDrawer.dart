import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 110, 5, 5),
            ),
            child: Text(
              'Menü',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Ayarlar',
            onTap: () {
              // Ayarlar işlemi
            },
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
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
