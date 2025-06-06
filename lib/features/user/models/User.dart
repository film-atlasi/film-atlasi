// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';

class User {
  final String? uid;
  final String? firstName;
  final String? lastName;
  final String? surname;
  final String? userName;
  String? profilePhotoUrl;
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
  final int? age;
  final String? city;
  final Timestamp? createdAt;
  final String? email;
  int? posts;

  User(
      {this.uid,
      this.posts,
      this.firstName,
      this.surname,
      this.userName,
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
      this.age,
      this.city,
      this.createdAt,
      this.email,
      this.lastName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'surname': surname,
      'userName': userName,
      'profilePhotoUrl': profilePhotoUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'job': job,
      'currentlyWatchingMovie': currentlyWatchingMovie?.toMap(),
      'birthDate': birthDate?.toIso8601String(),
      'books': books,
      'followers': followers,
      'following': following,
      'reviews': reviews,
      'quotes': quotes,
      'messages': messages,
      'age': age,
      'city': city,
      'createdAt': createdAt?.toDate().toIso8601String(),
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] as String?,
      surname: map['surname'] as String?,
      userName: map['userName'] as String?,
      profilePhotoUrl: map['profilePhotoUrl'] as String?,
      coverPhotoUrl: map['coverPhotoUrl'] as String?,
      job: map['job'] as String?,
      currentlyWatchingMovie: map['currentlyWatchingMovie'] != null
          ? Movie.fromMap(map['currentlyWatchingMovie'] as Map<String, dynamic>)
          : null,
      birthDate: map['birthDate'] != null
          ? DateTime.parse(map['birthDate'] as String)
          : null,
      books: map['books'] as int?,
      followers: map['followers'] ?? 0 as int?,
      following: map['following'] ?? 0 as int?,
      reviews: map['reviews'] as int?,
      quotes: map['quotes'] as int?,
      messages: map['messages'] as int?,
      age: map['age'] as int?,
      city: map['city'] as String?,
      createdAt:
          map['createdAt'] != null ? (map['createdAt'] as Timestamp) : null,
      email: map['email'] as String?,
    );
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      posts: data['posts'] ?? 0,
      userName: data['userName'].toString().toLowerCase(),
      firstName: data['firstName'] ?? '',
      email: data['email'] ?? '',
      city: data['city'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      age: data['age'] ?? 0,
      job: data['job'] ?? '',
      followers: data['followers'] ?? 0,
      following: data['following'] ?? 0,
      lastName: data['lastName'] ?? "",
      profilePhotoUrl: data['profilePhotoUrl'] ?? "", // ✅ EKLENDİ!
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
