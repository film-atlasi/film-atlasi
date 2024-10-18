import 'package:film_atlasi/data/models/film_post.dart';
import 'package:film_atlasi/presentation/widgets/film_post_card.dart';
import 'package:flutter/material.dart';
//import 'main.dart';
import 'filmekle.dart';

class FilmSocialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Atlası',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FilmFeedScreen(),
    );
  }
}
// Temel MaterialApp yapısını kuruyoruz

class FilmFeedScreen extends StatelessWidget {
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
  ];
  // Film postlarını bir liste olarak tanımlıyoruz

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Arka plan rengi
      appBar: AppBar(
        title: Text('Film Atlası'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // Favoriler butonu
            },
          ),
        ],
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
        items: [
          // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          //BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Keşfet'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Mesaj'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xf04d6, fontFamily: 'MaterialIcons')),
            label: 'Diğer', // Eksik olan label parametresini ekledik
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton( // Film ekleme butonu
        onPressed: () {// Butona basıldığında
          showModalBottomSheet(// Modal açılır
            context: context,// Context
            builder: (BuildContext context) {// Modal içeriği
              return FilmEkleWidget(); // Film ekleme widget'ı
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
