import 'package:film_atlasi/features/movie/screens/Anasayfa.dart';
import 'package:film_atlasi/features/movie/screens/DiscoverPage.dart';
import 'package:film_atlasi/features/user/screens/Profile.dart';
import 'package:film_atlasi/features/movie/widgets/FilmEkle.dart';
import 'package:flutter/material.dart';

class FilmAtlasiApp extends StatefulWidget {
  const FilmAtlasiApp({super.key});

  @override
  State<FilmAtlasiApp> createState() => _FilmAtlasiAppState();
}

class _FilmAtlasiAppState extends State<FilmAtlasiApp> {
  int pageIndex = 0;
  final List<Widget> _pages = const [
    Anasayfa(),
    DiscoverPage(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[pageIndex],
      bottomNavigationBar: buildBottomBar(context, pageIndex),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () {
        showModalBottomSheet(
          // Modal açılır
          context: context, // Context
          builder: (BuildContext context) {
            // Modal içeriği
            return FilmEkleWidget(); // Film ekleme widget'ı
          },
        );
      },
      child: Icon(Icons.add),
      // backgroundColor: Colors.blueGrey,
    );
  }

  BottomNavigationBar buildBottomBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      backgroundColor: Colors.black, // Arka plan siyah
      selectedItemColor:
          const Color.fromARGB(255, 110, 5, 5), // Seçilen ikon rengi
      unselectedItemColor: Colors.grey, // Seçilmemiş ikon rengi
      showSelectedLabels: false, // Seçilen item etiketlerini gizle
      showUnselectedLabels: false, // Seçilmemiş item etiketlerini gizle
      currentIndex: currentIndex, // Seçili olan öğeyi belirler
      onTap: (value) {
        setState(() {
          pageIndex = value;
        });
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
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.search), // Arama ikonu
        //   label: 'Keşfet',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person), // Mesaj ikonu
          label: 'Hesabım',
        ),
      ],
    );
  }
}
