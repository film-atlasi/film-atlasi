import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/movie/widgets/FilmEkle.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FilmSeedPage extends StatelessWidget {
  FilmSeedPage({super.key});
  final Movie movie = Movie(
      id: 1,
      title: "sidar",
      overview: "deneme",
      posterPath: "deneme",
      voteAverage: 9.0);

  late List<MoviePost> moviePosts = [
    MoviePost(
        user: User(username: "sidar"),
        movie: movie,
        likes: 12,
        comments: 12,
        content: "dnemefşwfk",
        title: "title")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: moviePosts.length,
        itemBuilder: (context, index) {
          final post = moviePosts[index];
          return MoviePostCard(moviePost: post);
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
