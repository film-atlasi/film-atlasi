import 'package:film_atlasi/app.dart';
import 'package:film_atlasi/features/movie/screens/FilmSeed.dart';
import 'package:film_atlasi/features/movie/screens/FollowingFeedPage.dart';
import 'package:film_atlasi/features/movie/screens/Message/DMPage.dart';
import 'package:film_atlasi/features/movie/screens/NewsScreen.dart';
import 'package:film_atlasi/features/movie/widgets/CustomDrawer.dart';
import 'package:film_atlasi/features/movie/widgets/CustomTabBar.dart';
import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:film_atlasi/features/movie/widgets/Notifications/notificationButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  AnasayfaState createState() => AnasayfaState();
}

class AnasayfaState extends State<Anasayfa>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          Scaffold(
            drawer: CustomDrawer(), // Drawer bileşeni burada çağrıldı.
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    title: Text("Film Atlası".toUpperCase()),
                    centerTitle: true,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const FilmAraWidget(mode: "film_incele")),
                        ),
                      ),
                      NotificationsButton(),
                      IconButton(
                          onPressed: () {
                            _pageController.animateToPage(
                              1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            Provider.of<VisibilityProvider>(context,
                                    listen: false)
                                .toggleVisibility();
                          },
                          icon: Icon(Icons.send_rounded))
                    ],
                    pinned: true, // Kaydırınca tamamen kaybolmasını sağlıyor
                    floating:
                        true, // Aşağı kaydırınca tekrar görünmesini sağlar
                    snap:
                        true, // Aşağı kaydırıldığında hızlıca geri gelmesini sağlar
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(50),
                      child: CustomTabBar(tabController: tabController),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: tabController,
                children: [
                  FilmSeedPage(),
                  FollowingFeedPage(),
                  NewsScreen(),
                ],
              ),
            ),
          ),
          DirectMessagePage(
            pageController: _pageController,
          )
        ],
      ),
    );
  }
}
