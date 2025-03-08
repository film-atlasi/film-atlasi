import 'package:film_atlasi/features/movie/screens/FilmAsistani.dart/widget/MovieIntroPage.dart';
import 'package:film_atlasi/features/movie/widgets/BottomNavigatorBar.dart';
import 'package:film_atlasi/features/movie/screens/Anasayfa.dart';
import 'package:film_atlasi/features/movie/screens/DiscoverPage.dart';
import 'package:film_atlasi/features/movie/widgets/FilmEkle.dart';
import 'package:film_atlasi/features/user/screens/UserPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FilmAtlasiApp extends StatefulWidget {
  const FilmAtlasiApp({super.key});

  @override
  State<FilmAtlasiApp> createState() => _FilmAtlasiAppState();
}

class _FilmAtlasiAppState extends State<FilmAtlasiApp> {
  int _selectedIndex = 0;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  List<Widget> get _screens => [
        _selectedIndex == 0 ? Anasayfa() : Container(),
        _selectedIndex == 1 ? MovieIntroPage() : Container(),
        _selectedIndex == 2 ? DiscoverPage() : Container(),
        _selectedIndex == 3
            ? UserPage(
                userUid: currentUser!.uid,
                fromProfile: true,
              )
            : Container(),
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
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return FilmEkleWidget();
            },
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
