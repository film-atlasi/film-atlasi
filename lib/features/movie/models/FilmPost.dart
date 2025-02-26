// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:film_atlasi/features/movie/models/Movie.dart';

class MoviePost {
  final String postId;
  final String userId;
  final String username;
  final String firstName;
  final String userPhotoUrl;
  final String filmName;
  final String filmId;
  final String filmIcerik;
  final int likes;
  final int comments;
  String content;
  bool isQuote;
  final double rating; // ⭐️ Kullanıcının verdiği puan
  final Timestamp timestamp;
  MoviePost({
    required this.postId,
    required this.userId,
    required this.username,
    required this.firstName,
    required this.userPhotoUrl,
    required this.filmName,
    required this.filmId,
    required this.filmIcerik,
    required this.likes,
    required this.comments,
    required this.content,
    required this.isQuote,
    required this.rating,
    required this.timestamp,
  });

  factory MoviePost.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MoviePost(
      postId: data['postId'] as String,
      userId: data['userId'] as String,
      username: data['username'] as String,
      firstName: data['firstName'] as String,
      userPhotoUrl: data['userPhotoUrl'] as String,
      likes: data['likes'] as int,
      filmIcerik: data["filmIcerik"],
      filmId: data['filmId'],
      filmName: data['filmName'],
      comments: data['comments'] as int,
      content: data['content'] as String,
      isQuote: data['isQuote'] as bool,
      rating: data['rating'] as double,
      timestamp: data['timestamp'] as Timestamp,
    );
  }

  factory MoviePost.fromJson(String source) =>
      MoviePost.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'userId': userId,
      'username': username,
      'firstName': firstName,
      'userPhotoUrl': userPhotoUrl,
      'filmName': filmName,
      'filmId': filmId,
      'filmIcerik': filmIcerik,
      'likes': likes,
      'comments': comments,
      'content': content,
      'isQuote': isQuote,
      'rating': rating,
      'timestamp': timestamp,
    };
  }

  factory MoviePost.fromMap(Map<String, dynamic> map) {
    return MoviePost(
      postId: map['postId'] as String,
      userId: map['userId'] as String,
      username: map['username'] as String,
      firstName: map['firstName'] as String,
      userPhotoUrl: map['userPhotoUrl'] as String,
      filmName: map['filmName'] as String,
      filmId: map['filmId'] as String,
      filmIcerik: map['filmIcerik'] as String,
      likes: map['likes'] as int,
      comments: map['comments'] as int,
      content: map['content'] as String,
      isQuote: map['isQuote'] as bool,
      rating: map['rating'] as double,
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());
}
