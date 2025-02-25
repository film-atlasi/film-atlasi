import 'package:film_atlasi/features/movie/widgets/BottomNavigatorBar.dart';
import 'package:film_atlasi/features/movie/screens/Anasayfa.dart';
import 'package:film_atlasi/features/movie/screens/DiscoverPage.dart';
import 'package:film_atlasi/features/user/screens/Profile.dart';
import 'package:flutter/material.dart';

class FilmAtlasiApp extends StatefulWidget {
  const FilmAtlasiApp({super.key});

  @override
  State<FilmAtlasiApp> createState() => _FilmAtlasiAppState();
}

class _FilmAtlasiAppState extends State<FilmAtlasiApp> {
  int _selectedIndex = 0;
  List<Widget> get _screens => [
        _selectedIndex == 0 ? Anasayfa() : Container(),
        _selectedIndex == 1 ? DiscoverPage() : Container(),
        _selectedIndex == 2 ? ProfileScreen() : Container(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
