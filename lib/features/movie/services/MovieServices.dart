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
}
