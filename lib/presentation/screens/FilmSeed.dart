import 'package:film_atlasi/data/models/Film.dart';
import 'package:film_atlasi/data/models/FilmPost.dart';
import 'package:film_atlasi/data/models/User.dart';
import 'package:film_atlasi/presentation/screens/filmekle.dart';
import 'package:film_atlasi/presentation/widgets/FilmPostCard.dart';
import 'package:flutter/material.dart';

class FilmSeedPage extends StatelessWidget {
  FilmSeedPage({super.key});
  final Film film = Film();

  late List<FilmPost> filmPosts = [
    FilmPost(
      user: new User(
          name: "celal",
          surname: "dinc",
          username: "celaldnc",
          profilePhotoUrl: "null",
          job: "software"),
      film: film,
      title: "güzel film",
      content: "valla",
      likes: 150,
      comments: 24,
    ),
    FilmPost(
      user: new User(
          name: "celal",
          surname: "dinc",
          username: "celaldnc",
          profilePhotoUrl: "null",
          job: "software"),
      title: "güzel film",
      content: "valla",
      film: film,
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
