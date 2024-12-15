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
    List<Widget> actions = [
      IconButton(
        icon: const Icon(Icons.search, color: Colors.white), // Arama ikonu
        onPressed: () {
          // Arama butonu fonksiyonu
        },
      ),
      IconButton(
        icon: const Icon(Icons.notifications_outlined, color: Colors.white),
        onPressed: () {
          // Bildirim butonu fonksiyonu
        },
      ),
    ];
    return Scaffold(
      appBar: buildAppBar(textTheme, actions),
      body: buildTabBarView(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 110, 5, 5),
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
              leading: Icon(Icons.settings),
              title: Text('Ayarlar'),
              onTap: () {
                // Ayarlar için işlem
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Gizlilik'),
              onTap: () {
                // Gizlilik için işlem
              },
            ),
            ListTile(
              leading: Icon(Icons.palette),
              title: Text('Tema'),
              onTap: () {
                // Tema için işlem
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(TextTheme textTheme, List<Widget> actions) {
    return AppBar(
      title: Text(
        AppConstants.AppName.toUpperCase(),
        style: textTheme.headlineSmall?.copyWith(color: AppConstants.red),
      ),
      actions: actions,
      bottom: TabBar(
        controller: tabController,
        tabs: const [
          Tab(text: 'Akış'),
          Tab(text: 'Takipler'),
          //Tab(text: 'Popüler'),
        ],
      ),
    );
  }

  Widget buildTabBarView() {
    return TabBarView(
      controller: tabController,
      children: [
        FilmSeedPage(),
        Center(child: Text('Takipler İçeriği')),
        Center(child: Text('Popüler İçeriği')),
      ],
    );
  }
}
