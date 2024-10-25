import 'package:flutter/material.dart';
import 'filmekle.dart';

class FilmSocialApp extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _FilmFeedScreen createState() =>
      _FilmFeedScreen(); // Doğru state sınıfını döndürün
}

class _FilmFeedScreen extends State<FilmSocialApp> {
  final List<FilmPost> filmPosts = [
    FilmPost(
      username: 'celal',
      filmName: 'Inception',
      filmPosterUrl: "", // Görsel kaldırıldı
      likes: 150,
      comments: 24,
    ),
    FilmPost(
      username: 'user2',
      filmName: 'The Matrix',
      filmPosterUrl: "", // Görsel kaldırıldı
      likes: 320,
      comments: 45,
    ),
    FilmPost(
      username: 'user2',
      filmName: 'The Matrix',
      filmPosterUrl: "", // Görsel kaldırıldı
      likes: 320,
      comments: 45,
    ),
  ];
  // Film postlarını bir liste olarak tanımlıyoruz

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 17, 17), // Arka plan rengi
      appBar: AppBar(
        title: Text('FİLM ATLASI',
            style: TextStyle(fontSize: 24, color: Colors.red)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white), // Arama ikonu
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
            icon: Icon(Icons.menu, color: Colors.white), // Menü ikonu
            onPressed: () {
              // Menü butonu fonksiyonu
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Akış', style: TextStyle(color: Colors.white)),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                  ), // Kırmızı nokta
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Takipler', style: TextStyle(color: Colors.grey)),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                  ), // Kırmızı nokta
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Popüler', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: filmPosts.length, // Liste eleman sayısı
        itemBuilder: (context, index) {
          final post = filmPosts[index];
          return FilmPostCard(filmPost: post);
          // Film postlarını listeliyoruz
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Arka plan siyah
        selectedItemColor: Color.fromARGB(255, 52, 1, 1), // Seçilen ikon rengi
        unselectedItemColor: Colors.grey, // Seçilmemiş ikon rengi
        showSelectedLabels: false, // Seçilen item etiketlerini gizle
        showUnselectedLabels: false, // Seçilmemiş item etiketlerini gizle
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Ana sayfa ikonu
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore), // Keşfet ikonu
            label: 'Keşfet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), // Arama ikonu
            label: 'Keşfet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message), // Mesaj ikonu
            label: 'Mesaj',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Profil ikonu
            label: 'Profil',
          ),
        ],
      ),

      floatingActionButton:
          buildfilmeklemebutton(context), // Film ekleme butonu
    );
  }

  FloatingActionButton buildfilmeklemebutton(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: () {
        showModalBottomSheet(
          // Modal açılır
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          context: context, // Context
          builder: (BuildContext context) {
            return SizedBox(
              height: 300,
              child: FilmEkleWidget(),
            );
          },
        );
      },
      child: Icon(Icons.add),
      backgroundColor: const Color.fromARGB(255, 20, 151, 217),
    );
  }
}
// Film listesi ve UI tasarımı

class FilmPostCard extends StatelessWidget {
  final FilmPost filmPost;

  FilmPostCard({required this.filmPost});
  // Film postunu tanımlayan yapı

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey, // Görsel yerine gri daire
            ),
            title: Text(filmPost.username),
            subtitle: Text(filmPost.filmName),
            trailing: Icon(Icons.more_vert),
          ),
          // Film postunun başlığı ve kullanıcı bilgileri
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite_border),
                    SizedBox(width: 8),
                    Text('${filmPost.likes} begeni'),
                    // Beğeni sayısı
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.comment),
                    SizedBox(width: 8),
                    Text('${filmPost.comments} yorum'),
                    // Yorum sayısı
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// Film postlarını kart şeklinde görüntülüyoruz

class FilmPost {
  final String username;
  final String filmName;
  final String filmPosterUrl; // Poster kaldırıldı
  final int likes;
  final int comments;

  FilmPost({
    required this.username,
    required this.filmName,
    required this.filmPosterUrl,
    required this.likes,
    required this.comments,
  });
}
// FilmPost sınıfı, her film postunun temel özelliklerini içerir
