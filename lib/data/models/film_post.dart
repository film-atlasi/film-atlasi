class FilmPost {
  final String username;
  final String filmName;
  final String filmPosterUrl; // Poster kaldırıldı
  final int likes;
  final int comments;

  FilmPost({
    required this.username,
    required this.filmName,
    required this.filmPosterUrl,
    required this.likes,
    required this.comments,
  });
}
// FilmPost sınıfı, her film postunun temel özelliklerini içerir
