import 'package:film_atlasi/presentation/screens/Anasayfa.dart';
import 'package:film_atlasi/presentation/screens/DiscoverPage.dart';
import 'package:flutter/material.dart';

class FilmAtlasiApp extends StatefulWidget {
  const FilmAtlasiApp({super.key});

  @override
  State<FilmAtlasiApp> createState() => _FilmAtlasiAppState();
}

class _FilmAtlasiAppState extends State<FilmAtlasiApp> {
  final List<Widget> _pages = const [Anasayfa(), DiscoverPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[1],
      bottomNavigationBar: buildBottomBar(),
    );
  }

  BottomNavigationBar buildBottomBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black, // Arka plan siyah
      selectedItemColor: Color.fromARGB(255, 52, 1, 1), // Seçilen ikon rengi
      unselectedItemColor: Colors.grey, // Seçilmemiş ikon rengi
      showSelectedLabels: false, // Seçilen item etiketlerini gizle
      showUnselectedLabels: false, // Seçilmemiş item etiketlerini gizle
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home), // Ana sayfa ikonu
          label: 'Ana Sayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore), // Keşfet ikonu
          label: 'Keşfet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search), // Arama ikonu
          label: 'Keşfet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message), // Mesaj ikonu
          label: 'Mesaj',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person), // Profil ikonu
          label: 'Profil',
        ),
      ],
    );
  }
}
