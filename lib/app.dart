import 'package:film_atlasi/features/movie/screens/Anasayfa.dart';
import 'package:film_atlasi/features/movie/screens/DiscoverPage.dart';
import 'package:film_atlasi/features/user/screens/Profile.dart';
import 'package:film_atlasi/features/movie/widgets/FilmEkle.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class FilmAtlasiApp extends StatefulWidget {
  const FilmAtlasiApp({super.key});

  @override
  State<FilmAtlasiApp> createState() => _FilmAtlasiAppState();
}

class _FilmAtlasiAppState extends State<FilmAtlasiApp> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      Anasayfa(),
      DiscoverPage(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Ana Sayfa",
        activeColorPrimary: const Color.fromARGB(255, 110, 5, 5),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.explore),
        title: "Keşfet",
        activeColorPrimary: const Color.fromARGB(255, 110, 5, 5),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: "Hesabım",
        activeColorPrimary: const Color.fromARGB(255, 110, 5, 5),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            navBarStyle: NavBarStyle
                .style6, // Seçenekleri değiştirerek farklı stilleri deneyebilirsin.
            backgroundColor: Colors.black,
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: Colors.black,
            ),
          ),
          Positioned(
            bottom: 80, // FloatingActionButton'ın konumunu ayarla
            right: 20,
            child: buildFloatingActionButton(context),
          ),
        ],
      ),
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
