// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/user/models/User.dart';

class MoviePost {
  final User user;
  final Movie movie;
  final int likes;
  final int comments;
  final String content;

  MoviePost(
      {required this.user,
      required this.movie,
      required this.likes,
      required this.comments,
      required this.content});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'movie': movie.toMap(),
      'likes': likes,
      'content': content,
      'comments': comments,
    };
  }

  factory MoviePost.fromMap(Map<String, dynamic> map) {
    return MoviePost(
        user: User.fromMap(map['user'] as Map<String, dynamic>),
        movie: Movie.fromMap(map['movie'] as Map<String, dynamic>),
        likes: map['likes'] as int,
        comments: map['comments'] as int,
        content: map['content'] as String);
  }

  String toJson() => json.encode(toMap());

  factory MoviePost.fromJson(String source) =>
      MoviePost.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MovieInceleme extends MoviePost {
  final double rank;
  MovieInceleme({
    required super.user,
    required super.movie,
    required super.likes,
    required super.comments,
    required super.content,
    required this.rank,
  });

  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['rank'] = rank;
    return map;
  }

  factory MovieInceleme.fromMap(Map<String, dynamic> map) {
    return MovieInceleme(
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      movie: Movie.fromMap(map['movie'] as Map<String, dynamic>),
      likes: map['likes'] as int,
      comments: map['comments'] as int,
      content: map['content'] as String,
      rank: map['rank'] as double,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory MovieInceleme.fromJson(String source) =>
      MovieInceleme.fromMap(json.decode(source) as Map<String, dynamic>);
}
