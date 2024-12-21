import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActorService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = 'c427167528d75438842677fbca3866fe';

  /// Film ID'sine göre ilk 3 aktörü döndüren fonksiyon
  static Future<List<Actor>> fetchTopThreeActors(int movieId, int count) async {
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
        return allActors.take(count).toList();
      } else {
        throw Exception('Filmdeki oyuncular alınamadı.');
      }
    } catch (e) {
      print('Hata: $e');
      return [];
    }
  }

  static Future<Actor> getDirector(String movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final crew = data['crew'] as List;
        final director = crew.firstWhere(
          (member) => member['job'] == 'Director',
          orElse: () => null, // Yönetmen bulunamazsa null döner
        );

        if (director != null) {
          return Actor.fromJson(
              director); // Yönetmen bilgisi Actor modeline dönüştürülüyor
        } else {
          throw Exception('Yönetmen bulunamadı.');
        }
      } else {
        throw Exception('Yönetmen bilgisi alınamadı.');
      }
    } catch (e) {
      print('Hata: $e');
      return Actor(name: "Bilinmeyen Yönetmen", character: "Yönetmen");
    }
  }
}
