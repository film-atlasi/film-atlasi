// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:film_atlasi/features/movie/models/Movie.dart';

class User {
  final String? name;
  final String? surname;
  final String? username;
  final String? profilePhotoUrl;
  final String? coverPhotoUrl;
  final String? job;
  final Movie? currentlyWatchingMovie;
  final DateTime? birthDate;
  final int? books;
  final int? followers;
  final int? following;
  final int? reviews;
  final int? quotes;
  final int? messages;

  User({
    this.name,
    this.surname,
    this.username,
    this.profilePhotoUrl,
    this.coverPhotoUrl,
    this.job,
    this.currentlyWatchingMovie,
    this.birthDate,
    this.books,
    this.followers,
    this.following,
    this.reviews,
    this.quotes,
    this.messages,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'surname': surname,
      'username': username,
      'profilePhotoUrl': profilePhotoUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'job': job,
      'currentlyWatchingMovie': currentlyWatchingMovie?.toMap(),
      'birthDate': birthDate?.millisecondsSinceEpoch,
      'books': books,
      'followers': followers,
      'following': following,
      'reviews': reviews,
      'quotes': quotes,
      'messages': messages,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] != null ? map['name'] as String : null,
      surname: map['surname'] != null ? map['surname'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      profilePhotoUrl: map['profilePhotoUrl'] != null
          ? map['profilePhotoUrl'] as String
          : null,
      coverPhotoUrl:
          map['coverPhotoUrl'] != null ? map['coverPhotoUrl'] as String : null,
      job: map['job'] != null ? map['job'] as String : null,
      currentlyWatchingMovie: map['currentlyWatchingMovie'] != null
          ? Movie.fromMap(map['currentlyWatchingMovie'] as Map<String, dynamic>)
          : null,
      birthDate: map['birthDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['birthDate'] as int)
          : null,
      books: map['books'] != null ? map['books'] as int : null,
      followers: map['followers'] != null ? map['followers'] as int : null,
      following: map['following'] != null ? map['following'] as int : null,
      reviews: map['reviews'] != null ? map['reviews'] as int : null,
      quotes: map['quotes'] != null ? map['quotes'] as int : null,
      messages: map['messages'] != null ? map['messages'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
