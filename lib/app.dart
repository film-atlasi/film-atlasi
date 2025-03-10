import 'package:film_atlasi/features/movie/screens/FilmAsistani.dart/widget/MovieIntroPage.dart';
import 'package:film_atlasi/features/movie/widgets/BottomNavigatorBar.dart';
import 'package:film_atlasi/features/movie/screens/Anasayfa.dart';
import 'package:film_atlasi/features/movie/screens/DiscoverPage.dart';
import 'package:film_atlasi/features/movie/widgets/FilmEkle.dart';
import 'package:film_atlasi/features/user/screens/UserPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisibilityProvider with ChangeNotifier {
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  void toggleVisibility() {
    _isVisible = !_isVisible;
    notifyListeners();
  }
}

class FilmAtlasiApp extends StatefulWidget {
  const FilmAtlasiApp({super.key});

  @override
  State<FilmAtlasiApp> createState() => _FilmAtlasiAppState();
}

class _FilmAtlasiAppState extends State<FilmAtlasiApp> {
  int _selectedIndex = 0;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      0, // Çünkü sadece Anasayfa'nın içinde farklı sekmeler var
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VisibilityProvider(),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            Anasayfa(),
            MovieIntroPage(),
            DiscoverPage(),
            UserPage(
              userUid: currentUser!.uid,
              fromProfile: true,
            ),
          ],
        ),
        bottomNavigationBar: Consumer<VisibilityProvider>(
          builder: (context, visibilityProvider, child) {
            return visibilityProvider.isVisible
                ? CustomBottomNavigationBar(
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                  )
                : SizedBox.shrink();
          },
        ),
        floatingActionButton: Consumer<VisibilityProvider>(
          builder: (context, visibilityProvider, child) {
            return visibilityProvider.isVisible
                ? FloatingActionButton(
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
                    child: const Icon(Icons.add),
                  )
                : SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
