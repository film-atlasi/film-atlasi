// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

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
  final DocumentSnapshot? documentSnapshot;
  String content;
  bool isQuote;
  final double rating; // ⭐️ Kullanıcının verdiği puan
  final Timestamp timestamp;
  MoviePost({
    this.documentSnapshot,
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
      rating: (data['rating'] is int)
          ? (data['rating'] as int).toDouble()
          : (data['rating'] as double? ?? 0.0),
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
  //var a = {firstName: ayca aktekin, username: moonca, content: kürt adam, timestamp: Timestamp(seconds=1740606238, nanoseconds=107000000), comments: 0, userPhotoUrl: https://firebasestorage.googleapis.com/v0/b/film-atlasi.firebasestorage.app/o/profile_pictures%2FlyhAYFFooneE1WhpCNhBDHgY2q52.jpg?alt=media&token=4c47f938-62fa-44f0-a9c4-2be60ccd8b2a, filmName: Kurt Adam, likes: 0, userId: lyhAYFFooneE1WhpCNhBDHgY2q52, likedUsers: [], rating: 3.5, isQuote: false, movie: 710295, filmIcerik: Evliliği yıpranmakta olan Blake, eşi Charlotte’u şehirden uzaklaşıp Oregon kırsalındaki çocukluk evine gitmeye ikna eder. Gece yarısı çiftlik evine vardıklarında, görünmeyen bir hayvanın saldırısına uğrarlar ve yaratık evin çevresinde dolaşırken kendilerini evin içine barikat kurarak korumaya çalışırlar. Ancak gece uzadıkça Blake tuhaf bir şekilde davranmaya başlar ve tanınmayacak bir şeye dönüşür. https://justwatch.pro/movie/710295/wolf-man, filmId: 710295};

  factory MoviePost.fromMap(Map<String, dynamic> map) {
    return MoviePost(
      postId: map['postId'] as String,
      userId: map['userId'] as String, //
      username: map['username'] as String, //
      firstName: map['firstName'] as String, //
      userPhotoUrl: map['userPhotoUrl'] as String, //
      filmName: map['filmName'] as String,
      filmId: map['filmId'] as String,
      filmIcerik: map['filmIcerik'] as String,
      likes: map['likes'] as int, //
      comments: map['comments'] as int, //
      content: map['content'] as String, //
      isQuote: map['isQuote'] as bool, //
      rating: (map['rating'] is int)
          ? (map['rating'] as int).toDouble()
          : map['rating'] as double, //
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  factory MoviePost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MoviePost(
        postId: doc.id,
        userId: data['userId'] as String,
        username: data['username'] as String,
        firstName: data['firstName'] as String,
        userPhotoUrl: data['userPhotoUrl'] as String,
        filmName: data['filmName'] as String,
        filmId: data['filmId'] as String,
        filmIcerik: data['filmIcerik'] as String,
        likes: data['likes'] as int,
        comments: data['comments'] as int,
        content: data['content'] as String,
        isQuote: data['isQuote'] as bool,
        rating: (data['rating'] is int)
            ? (data['rating'] as int).toDouble()
            : data['rating'] as double, //
        timestamp: data['timestamp'] as Timestamp,
        documentSnapshot: doc);
  }

  String toJson() => json.encode(toMap());
}
