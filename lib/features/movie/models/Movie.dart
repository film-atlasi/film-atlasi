import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:flutter/material.dart';

class Movie {
  final String id; // Film ID'si
  final String title; // Film Başlığı
  final String posterPath; // Poster URL'si
  final String overview; // Film Özeti
  final double voteAverage; // IMDB Puanı
  final String? releaseDate; // Yayınlanış Tarihi
  final List<int>? genreIds; // Tür ID'leri (genre_ids)
  final List<String>? watchProviders; // 🔥 Yeni alan
  final Color dominantColorDark;
  final Color dominantColorLight; // 🎨 Renk paleti
  final Map<String, String>?
      watchProvidersWithIcons; // 🔥 Platform adı + İkon URL’si

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage, // IMDB Puanı
    this.releaseDate,
    this.genreIds,
    this.watchProviders, // 🔥 Yeni alan
    this.watchProvidersWithIcons,
    this.dominantColorDark = Colors.black,
    this.dominantColorLight = Colors.grey, // 🎨 Renk paleti
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final genreIds =
        (json['genre_ids'] as List<dynamic>?)?.map((id) => id as int).toList();

    // API'den gelen "watch/providers" verisini işle
    List<String> providers = [];
    Map<String, String> providersWithIcons = {};
    if (json['watch/providers'] != null &&
        json['watch/providers']['results'] != null) {
      final results = json['watch/providers']['results'];
      if (results['TR'] != null && results['TR']['flatrate'] != null) {
        for (var provider in results['TR']['flatrate']) {
          providers.add(provider['provider_name'].toString());
          providersWithIcons[provider['provider_name'].toString()] =
              "https://image.tmdb.org/t/p/w200${provider['logo_path']}";
        }
      }
    }

    return Movie(
      id: json['id'].toString(),
      title: json['title'] ?? 'Başlık Bilinmiyor',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? 'Özet bulunamadı',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'],
      genreIds: genreIds,
      watchProviders: providers.isNotEmpty ? providers : null,
      watchProvidersWithIcons:
          providersWithIcons.isNotEmpty ? providersWithIcons : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'overview': overview,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'watch_providers': watchProviders,
      'watch_providers_with_icons': watchProvidersWithIcons,
      'dominantColorDark': Helpers.colorToInt(dominantColorDark),
      'dominantColorLight': Helpers.colorToInt(dominantColorLight),
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'] ?? map['poster_path'],
      overview: map['overview'] ?? '',
      voteAverage: (map['vote_average'] ?? 0).toDouble(),
      releaseDate: map['release_date'],
      genreIds:
          (map['genre_ids'] as List<dynamic>?)?.map((id) => id as int).toList(),
      watchProviders: (map['watch_providers'] as List<dynamic>?)
          ?.map((p) => p.toString())
          .toList(),
      watchProvidersWithIcons:
          (map['watch_providers_with_icons'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value.toString())),
    );
  }
  factory Movie.fromFirebase(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Movie(
      id: doc.id,
      title: data['title'] ?? '',
      posterPath: data['posterPath'] ?? '',
      overview: data['overview'] ?? '',
      voteAverage: (data['vote_average'] ?? 0).toDouble(),
      releaseDate: data['release_date'] ?? '',
      genreIds: (data['genre_ids'] as List<dynamic>?)
              ?.map((id) => id as int)
              .toList() ??
          [],
      watchProviders: (data['watch_providers'] as List<dynamic>?)
          ?.map((p) => p.toString())
          .toList(),
      watchProvidersWithIcons:
          (data['watch_providers_with_icons'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value.toString())),
      dominantColorDark: Helpers.intToColor(data['dominantColorDark']),
      dominantColorLight: Helpers.intToColor(data['dominantColorLight']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'overview': overview,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'watch_providers': watchProviders,
      'watch_providers_with_icons': watchProvidersWithIcons,
    };
  }
}
