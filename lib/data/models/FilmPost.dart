// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:film_atlasi/data/models/Film.dart';
import 'package:film_atlasi/data/models/User.dart';

class FilmPost {
  final User user;
  final String title;
  final String content;
  final Film film;
  final int likes;
  final int comments;

  FilmPost(
      {required this.user,
      required this.film,
      required this.likes,
      required this.comments,
      required this.content,
      required this.title});
}

class FilmPostComment {
  final FilmPost filmPost;
  final String content;
  final int likes;
  FilmPostComment({
    required this.filmPost,
    required this.content,
    required this.likes,
  });
}
