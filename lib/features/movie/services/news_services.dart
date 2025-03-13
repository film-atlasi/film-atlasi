import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  static const String _apiKey = "9b08f996b74747bc847073321e14f736";
  static const String _baseUrl = "https://newsapi.org/v2/everything";

  Future<List<NewsArticle>> fetchNews(String query) async {
    final Uri url = Uri.parse("$_baseUrl?q=$query&language=tr&apiKey=$_apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List articles = data["articles"];

      print(
          "Gelen API Verisi: ${jsonEncode(data)}"); // API verisini terminale yazdır

      return articles.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception("Haberler yüklenemedi!");
    }
  }
}
