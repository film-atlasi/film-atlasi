class Movie {
  final String id; // Film ID'si
  final String title; // Film Başlığı
  final String posterPath; // Poster URL'si
  final String overview; // Film Özeti
  final double voteAverage; // IMDB Puanı
  final String? releaseDate; // Yayınlanış Tarihi
  final List<int>? genreIds; // Tür ID'leri (genre_ids)

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage, // IMDB Puanı
    this.releaseDate,
    this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final genreIds =
        (json['genre_ids'] as List<dynamic>?)?.map((id) => id as int).toList();

    return Movie(
      id: json['id'].toString(),
      title: json['title'] ?? 'Başlık Bilinmiyor',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? 'Özet bulunamadı',
      voteAverage: (json['vote_average'] ?? 0).toDouble(), // IMDB puanı
      releaseDate: json['release_date'],
      genreIds: genreIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'overview': overview,
      'vote_average': voteAverage, // IMDB Puanı
      'release_date': releaseDate,
      'genre_ids': genreIds,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'overview': overview,
      'vote_average': voteAverage, // IMDB Puanı
      'release_date': releaseDate,
      'genre_ids': genreIds,
    };
  }
}
