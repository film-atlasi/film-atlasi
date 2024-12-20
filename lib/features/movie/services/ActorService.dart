import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActorService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = 'c427167528d75438842677fbca3866fe';

  /// Film ID'sine göre ilk 3 aktörü döndüren fonksiyon
  static Future<List<Actor>> fetchTopThreeActors(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Actor> allActors = (data['cast'] as List)
            .map((actor) => Actor.fromJson(actor))
            .toList();

        // İlk 3 aktörü al ve döndür
        return allActors.take(3).toList();
      } else {
        throw Exception('Filmdeki oyuncular alınamadı.');
      }
    } catch (e) {
      print('Hata: $e');
      return [];
    }
  }
}
