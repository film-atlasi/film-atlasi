// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:film_atlasi/data/models/Film.dart';

class User {
  final String? name;
  final String? surname;
  final String? username;
  final String? profilePhotoUrl;
  final String? coverPhotoUrl;
  final String? job;
  final Film? currentlyWatchingFilm;
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
    this.currentlyWatchingFilm,
    this.birthDate,
    this.books,
    this.followers,
    this.following,
    this.reviews,
    this.quotes,
    this.messages,
  });
}
