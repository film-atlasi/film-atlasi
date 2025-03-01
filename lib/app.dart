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
  final GlobalKey<AnasayfaState> _anasayfaKey = GlobalKey<AnasayfaState>();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Anasayfa(key: _anasayfaKey),
      DiscoverPage(),
      ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[pageIndex],
      bottomNavigationBar: buildBottomBar(context, pageIndex),
      floatingActionButton: buildFloatingActionButton(context),
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
        BottomNavigationBarItem(
          icon: Icon(Icons.person), // Mesaj ikonu
          label: 'Hesabım',
        ),
      ],
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'uniqueHeroTag', // Benzersiz bir tag ekleyin
      shape: CircleBorder(),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return FilmEkleWidget();
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}
