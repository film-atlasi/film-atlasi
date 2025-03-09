import 'package:http/http.dart' as http;
import 'dart:convert';

class OyuncuYonetmenSearchService {
  final String _baseUrl = "https://api.themoviedb.org/3/search/person"; // TMDb API gibi düşünelim
  final String _apiKey = "c427167528d75438842677fbca3866fe"; // API Anahtarınızı ekleyin

  Future<List<dynamic>> search(String query) async {
    final url = Uri.parse("$_baseUrl?api_key=$_apiKey&query=$query");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] ?? [];
    } else {
      throw Exception("API hatası: ${response.statusCode}");
    }
  }
}
