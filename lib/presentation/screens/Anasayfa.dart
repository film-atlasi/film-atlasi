import 'package:film_atlasi/presentation/screens/FilmSeed.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/constants/AppConstants.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme _textTheme = Theme.of(context).textTheme;
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
      IconButton(
        icon: const Icon(Icons.menu, color: Colors.white), // Menü ikonu
        onPressed: () {
          // Menü butonu fonksiyonu
        },
      ),
    ];

    return Scaffold(
      appBar: buildAppBar(_textTheme, actions),
      body: buildTabBarView(),
    );
  }

  AppBar buildAppBar(TextTheme _textTheme, List<Widget> actions) {
    return AppBar(
      title: Text(
        AppConstants.AppName.toUpperCase(),
        style: _textTheme.headlineSmall?.copyWith(color: AppConstants.red),
      ),
      actions: actions,
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Akış'),
          Tab(text: 'Takipler'),
          Tab(text: 'Popüler'),
        ],
      ),
    );
  }

  Widget buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        FilmSeedPage(),
        Center(child: Text('Takipler İçeriği')),
        Center(child: Text('Popüler İçeriği')),
      ],
    );
  }
}
