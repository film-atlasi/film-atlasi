import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:flutter/material.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  MovieDetailsPage({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 32, 32),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Geri gitmek için Navigator.pop kullanılır
          },
        ),
        actions: [
          Icon(Icons.more_vert, color: Colors.black),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Görsel Alanı
              Container(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.error, size: 100, color: Colors.red),
                ),
              ),
              SizedBox(height: 16),

              // Yönetmen, Yıl, Süre, Oyuncular
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "yönetmen",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Yıl    süre",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "film türü",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "oyuncular",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Film Konusu
              Text(
                movie.overview,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              SizedBox(height: 16),

              // Herkese / Arkadaşlar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text("herkese")),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text("arkadaşlar")),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Kullanıcı Listesi
              Column(
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[400],
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Sizin İçin Alanı
              Text(
                "Sizin İçin",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  ...List.generate(
                    3,
                    (index) => Expanded(
                      child: Container(
                        height: 100,
                        margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
