// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/user/models/User.dart';

class MoviePost {
  final String postId;
  final User user;
  final Movie movie;
  final int likes;
  final int comments;
  String content;
  bool isQuote;

    final Timestamp timestamp;
  
  MoviePost(
      {required this.user,
      required this.postId,
      required this.movie,
      required this.likes,
      required this.comments,
      required this.content,
      required this.timestamp,

      this.isQuote = false,
      });

      


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'movie': movie.toMap(),
      'likes': likes,
      'content': content,
      'comments': comments,
      'timestamp': timestamp,
    };
  }

  factory MoviePost.fromMap(Map<String, dynamic> map) {
    return MoviePost(
        user: User.fromMap(map['user'] as Map<String, dynamic>),
        postId: map['postId'] as String,
        movie: Movie.fromMap(map['movie'] as Map<String, dynamic>),
        likes: map['likes'] as int,
        comments: map['comments'] as int,
        content: map['content'] as String,
         timestamp: map['timestamp'] as Timestamp, 
    );
  }

  String toJson() => json.encode(toMap());

  factory MoviePost.fromJson(String source) =>
      MoviePost.fromMap(json.decode(source) as Map<String, dynamic>);
}
