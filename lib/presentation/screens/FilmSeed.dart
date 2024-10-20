import 'package:film_atlasi/data/models/FilmPost.dart';
import 'package:film_atlasi/presentation/screens/filmekle.dart';
import 'package:film_atlasi/presentation/widgets/FilmPostCard.dart';
import 'package:flutter/material.dart';

class FilmSeedPage extends StatelessWidget {
  FilmSeedPage({super.key});

  final List<FilmPost> filmPosts = [
    FilmPost(
      username: 'celal',
      filmName: 'Inception',
      filmPosterUrl: "",
      likes: 150,
      comments: 24,
    ),
    FilmPost(
      username: 'user2',
      filmName: 'The Matrix',
      filmPosterUrl: "",
      likes: 320,
      comments: 45,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: filmPosts.length,
        itemBuilder: (context, index) {
          final post = filmPosts[index];
          return FilmPostCard(filmPost: post);
          // Film postlarını listeliyoruz
        },
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () {
        showModalBottomSheet(
          // Modal açılır
          context: context, // Context
          builder: (BuildContext context) {
            // Modal içeriği
            return FilmEkleWidget(); // Film ekleme widget'ı
          },
        );
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.blueGrey,
    );
  }
}
