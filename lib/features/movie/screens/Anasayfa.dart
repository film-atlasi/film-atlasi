import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/movie/screens/FilmSeed.dart';
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
              MaterialPageRoute(builder: (context) => const FilmAraWidget(mode: "film_incele")),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Bildirim işlemi
              print('Bildirimler tıklandı.');
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
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          FilmSeedPage(),
          const Center(child: Text('Takipler İçeriği')),
         const Center(child: Text('Popüler İçeriği')),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 110, 5, 5),
              ),
              child: Text(
                'Menü',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Ayarlar',
              onTap: () {
                // Ayarlar işlemi
              },
            ),
            _buildDrawerItem(
              icon: Icons.lock,
              title: 'Gizlilik',
              onTap: () {
                // Gizlilik işlemi
              },
            ),
            _buildDrawerItem(
              icon: Icons.palette,
              title: 'Tema',
              onTap: () {
                // Tema işlemi
              },
            ),
            _buildDrawerItem(
              icon: Icons.exit_to_app,
              title: 'Çıkış Yap',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/giris',
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildDrawerItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
