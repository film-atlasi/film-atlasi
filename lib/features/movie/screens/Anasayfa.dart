import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/movie/screens/FilmSeed.dart';
import 'package:film_atlasi/features/movie/screens/FollowingFeedPage.dart';
import 'package:film_atlasi/features/movie/screens/NewsScreen.dart';
import 'package:film_atlasi/features/movie/widgets/CustomDrawer.dart';
import 'package:film_atlasi/features/movie/widgets/CustomTabBar.dart';
import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:film_atlasi/features/movie/widgets/Notifications/notificationButton.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(), // Drawer bileşeni burada çağrıldı.
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(
                AppConstants.AppName.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: AppConstants.red),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const FilmAraWidget(mode: "film_incele")),
                  ),
                ),
                NotificationsButton(),
              ],
              pinned: true, // Kaydırınca tamamen kaybolmasını sağlıyor
              floating: true, // Aşağı kaydırınca tekrar görünmesini sağlar
              snap: true, // Aşağı kaydırıldığında hızlıca geri gelmesini sağlar
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
    );
  }
}
