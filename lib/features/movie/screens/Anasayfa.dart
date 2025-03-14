import 'package:film_atlasi/app.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/movie/screens/FilmSeed.dart';
import 'package:film_atlasi/features/movie/screens/FollowingFeedPage.dart';
import 'package:film_atlasi/features/movie/screens/Message/DMPage.dart';
import 'package:film_atlasi/features/movie/screens/NewsScreen.dart';
import 'package:film_atlasi/features/movie/services/MessageServices.dart';
import 'package:film_atlasi/features/movie/widgets/CustomDrawer.dart';
import 'package:film_atlasi/features/movie/widgets/CustomTabBar.dart';
import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:film_atlasi/features/movie/widgets/Notifications/notificationButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    if (!mounted) return; // 🔥 Widget ağaçtan kaldırıldıysa hata almamak için
    if (_pageController.page?.round() == 0) {
      Provider.of<VisibilityProvider>(context, listen: false).show();
    } else {
      Provider.of<VisibilityProvider>(context, listen: false).hide();
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged); // Listener'ı kaldır
    _pageController.dispose(); // Bellek sızıntısını önler
    tabController.dispose();
    super.dispose();
  }

  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
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
                          icon: StreamBuilder(
                            stream: MessageServices()
                                .getUnreadChatsCount(currentUserId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Icon(Icons.send);
                              }
                              return snapshot.data == 0
                                  ? Icon(Icons.send_rounded)
                                  : Stack(children: [
                                      const Icon(Icons.send_rounded),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  AppConstants(context)
                                                      .primaryColor,
                                              child: Text(
                                                snapshot.data.toString(),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              )))
                                    ]);
                            },
                          ))
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
