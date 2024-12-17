import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:film_atlasi/features/movie/models/Movie.dart';

class MovieService {
  final String apiKey = 'c427167528d75438842677fbca3866fe';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/search/movie?api_key=$apiKey&query=$query&language=tr-TR'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Film arama başarısız oldu');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&language=tr-TR'));

    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Film detayları alınamadı');
    }
  }

  //trend filmler için apı kullanımı
  Future<List<Movie>> getTrendingMovies({String timeWindow = 'week'}) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/trending/movie/$timeWindow?api_key=$apiKey&language=tr-TR'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data); // Gelen veriyi görmek için
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Trend filmler alınamadı');
    }
  }

  //BİLİM KURGU FİLMLERİ CEKME
  Future<List<Movie>> getTrendingSciFiMovies(
      {String timeWindow = 'day'}) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/trending/movie/$timeWindow?api_key=$apiKey&language=tr-TR'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Bilim Kurgu türündeki filmleri filtrele
      return (data['results'] as List)
          .where((movie) =>
              movie['genre_ids'] != null &&
              (movie['genre_ids'] as List).contains(878))
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Trend ve Bilim Kurgu filmleri alınamadı');
    }
  }

  //Romantik komedi
  Future<List<Movie>> getRomantikKomedi() async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/discover/movie?api_key=$apiKey&language=tr-TR&with_genres=10749,35&sort_by=vote_average.desc&vote_count.gte=100'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // En yüksek puanlı Romantik (10749) ve Komedi (35) türündeki filmleri al
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('En yüksek puanlı Romantik Komedi filmleri alınamadı');
    }
  }
}
