import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/movie/screens/FilmSeed.dart';
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
    // Sekme sayısına uygun olarak length: 3 olarak tanımlandı
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: buildAppBar(textTheme),
      body: buildTabBarView(),
      drawer: buildDrawer(),
    );
  }

  /// AppBar Yapısı
  AppBar buildAppBar(TextTheme textTheme) {
    return AppBar(
      title: Text(
        AppConstants.AppName.toUpperCase(),
        style: textTheme.headlineSmall?.copyWith(color: AppConstants.red),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Arama işlemi
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // Bildirim işlemi
          },
        ),
      ],
      bottom: TabBar(
        controller: tabController,
        tabs: const [
          Tab(text: 'Akış'),
          Tab(text: 'Takipler'),
          Tab(text: 'Popüler'),
        ],
      ),
    );
  }

  /// TabBarView Yapısı
  Widget buildTabBarView() {
    return TabBarView(
      controller: tabController,
      children: [
        FilmSeedPage(), // Birinci sayfa
        const Center(child: Text('Takipler İçeriği')), // İkinci sayfa
        const Center(child: Text('Popüler İçeriği')), // Üçüncü sayfa
      ],
    );
  }

  /// Drawer Menüsü
  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 110, 5, 5),
            ),
            child: Text(
              'Menü',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ayarlar'),
            onTap: () {
              // Ayarlar işlemi
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Gizlilik'),
            onTap: () {
              // Gizlilik işlemi
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Tema'),
            onTap: () {
              // Tema işlemi
            },
          ),
        ],
      ),
    );
  }
}
