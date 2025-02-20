import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/movie/screens/FilmSeed.dart';
import 'package:film_atlasi/features/movie/screens/NewsScreen.dart';
import 'package:film_atlasi/features/movie/widgets/CustomDrawer.dart';
import 'package:film_atlasi/features/movie/widgets/CustomTabBar.dart';
import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:flutter/material.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  AnasayfaState createState() => AnasayfaState();
}

class AnasayfaState extends State<Anasayfa>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              print('Bildirimler tıklandı.');
            },
          ),
        ],
        bottom:
            CustomTabBar(tabController: tabController), // Yeni TabBar widget'ı
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          FilmSeedPage(),
          const Center(child: Text('Takipler İçeriği')),
          NewsScreen(),
        ],
      ),
      drawer: const CustomDrawer(), // Drawer bileşeni burada çağrıldı.
    );
  }
}
