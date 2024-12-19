import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AlintiEkle extends StatefulWidget {
  final int movieId; // Dinamik olarak film ID'sini alacak

  AlintiEkle({required this.movieId});

  @override
  _AlintiEkleState createState() => _AlintiEkleState();
}

class _AlintiEkleState extends State<AlintiEkle> {
  List<Actor> cast =
      []; // Oyuncuları `Actor` modeline uygun bir liste olarak saklıyoruz
  bool isLoading =
      true; // Veriyi yüklediğimizi göstermek için bir durum kontrolü

  @override
  void initState() {
    super.initState();
    fetchCast(widget.movieId);
  }

  // API'den oyuncu bilgilerini çeken fonksiyon
  Future<void> fetchCast(int movieId) async {
    try {
      final actors = await getMovieActors(
          movieId); // getMovieActors fonksiyonunu kullanıyoruz
      setState(() {
        cast = actors; // Gelen oyuncuları listeye atıyoruz
        isLoading = false; // Yükleme tamamlandı
      });
    } catch (e) {
      print('Hata: $e');
      setState(() {
        isLoading = false; // Hata durumunda da yükleme tamamlanır
      });
    }
  }

  // getMovieActors fonksiyonu
  Future<List<Actor>> getMovieActors(int movieId) async {
    const String baseUrl = 'https://api.themoviedb.org/3';
    const String apiKey = 'c427167528d75438842677fbca3866fe';

    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['cast'] as List)
          .map((actor) => Actor.fromJson(actor))
          .toList();
    } else {
      throw Exception('Filmdeki oyuncular alınamadı.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Harry Potter Cast'), // Dinamik olarak filmin adını alabilirsiniz
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Yükleniyor gösterimi
          : cast.isEmpty
              ? Center(
                  child: Text(
                    'Oyuncu bilgisi bulunamadı.',
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : ListView.builder(
                  itemCount: cast.length,
                  itemBuilder: (context, index) {
                    final actor = cast[index]; // Her bir oyuncuyu alıyoruz
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: actor.profilePhotoUrl != null
                            ? NetworkImage(actor.profilePhotoUrl!)
                            : null,
                        backgroundColor: Colors.grey,
                        child: actor.profilePhotoUrl == null
                            ? Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      title: Text(actor.name),
                      subtitle: Text(actor.character),
                    );
                  },
                ),
    );
  }
}

