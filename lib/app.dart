import 'package:film_atlasi/presentation/screens/Anasayfa.dart';
import 'package:film_atlasi/presentation/screens/DiscoverPage.dart';
import 'package:film_atlasi/presentation/screens/Profile.dart';
import 'package:film_atlasi/provider/PageIndexProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilmAtlasiApp extends StatefulWidget {
  const FilmAtlasiApp({super.key});

  @override
  State<FilmAtlasiApp> createState() => _FilmAtlasiAppState();
}

class _FilmAtlasiAppState extends State<FilmAtlasiApp> {
  final List<Widget> _pages = const [Anasayfa(), DiscoverPage(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final pageIndex = Provider.of<PageIndexProvider>(context).menuIndex;
    return Scaffold(
      body: _pages[pageIndex],
      bottomNavigationBar: buildBottomBar(context, pageIndex),
    );
  }

  BottomNavigationBar buildBottomBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      backgroundColor: Colors.black, // Arka plan siyah
      selectedItemColor:
          const Color.fromARGB(255, 52, 1, 1), // Seçilen ikon rengi
      unselectedItemColor: Colors.grey, // Seçilmemiş ikon rengi
      showSelectedLabels: false, // Seçilen item etiketlerini gizle
      showUnselectedLabels: false, // Seçilmemiş item etiketlerini gizle
      currentIndex: currentIndex, // Seçili olan öğeyi belirler
      onTap: (value) {
        Provider.of<PageIndexProvider>(context, listen: false).menuIndex =
            value;
      },
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
          label: 'Mesajlar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person), // Mesaj ikonu
          label: 'Hesabım',
        ),
      ],
    );
  }
}
