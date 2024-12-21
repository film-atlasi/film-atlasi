import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/services/ActorService.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  MovieDetailsPage({required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Actor director = Actor(name: "name", character: "character");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDirector();
  }

  Future<void> getDirector() async {
    final dir = await ActorService.getDirector(widget.movie.id);
    setState(() {
      director = dir;
    });
  }

  final Map<int, String> genreMap = {
    28: "Aksiyon",
    12: "Macera",
    16: "Animasyon",
    35: "Komedi",
    80: "Suç",
    99: "Belgesel",
    18: "Dram",
    10751: "Aile",
    14: "Fantastik",
    36: "Tarih",
    27: "Korku",
    10402: "Müzik",
    9648: "Gizem",
    10749: "Romantik",
    878: "Bilim Kurgu",
    10770: "TV Filmi",
    53: "Gerilim",
    10752: "Savaş",
    37: "Western",
  };

  String reverseDate(String? releaseDate) {
    if (releaseDate == null || releaseDate.isEmpty) return 'Bilinmiyor';
    try {
      // Tarihi "-" karakterine göre ayır
      final parts = releaseDate.split('-');
      if (parts.length == 3) {
        // Gelen tarih sırasını ters çevir: Yıl-Ay-Gün -> Gün-Ay-Yıl
        final day = parts[2];
        final month = parts[1];
        final year = parts[0];

        // Ay numarasını Türkçe yazıya çevir
        const months = [
          'Ocak',
          'Şubat',
          'Mart',
          'Nisan',
          'Mayıs',
          'Haziran',
          'Temmuz',
          'Ağustos',
          'Eylül',
          'Ekim',
          'Kasım',
          'Aralık'
        ];
        final monthName = months[int.parse(month) - 1];

        return "$day $monthName $year"; // Ters çevrilmiş tarih
      }
      return 'Bilinmiyor';
    } catch (e) {
      return 'Bilinmiyor';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 6, 26),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 20, 13, 13),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Geri gitmek için Navigator.pop kullanılır
          },
        ),
        title: Text(
          widget.movie.title, // Filmin adını burada gösteriyoruz
          style: TextStyle(
            color: Colors.white, // Yazı rengi
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true, // Başlığı ortalamak için
        actions: [
          Icon(Icons.more_vert, color: Colors.white),
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
                  'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
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
                  // Yönetmen Bilgisi
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Yönetmen adı
                      Text(
                        director.name.isNotEmpty
                            ? director.name
                            : "Yönetmen Bilinmiyor",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Yönetmen fotoğrafı
                      CircleAvatar(
                        radius: 30, // Fotoğraf boyutu
                        backgroundImage: director.profilePhotoUrl != null
                            ? NetworkImage(director.profilePhotoUrl!)
                            : null,
                        backgroundColor: Colors.grey,
                        child: director.profilePhotoUrl == null
                            ? Icon(Icons.person, color: Colors.white, size: 30)
                            : null,
                      ),
                      SizedBox(
                          height:
                              16), // Fotoğraf ile diğer bilgiler arasında boşluk

                      Text(
                        "Yayınlanış Tarihi: ${reverseDate(widget.movie.releaseDate)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      // Türler
                      Text(
                        "Tür: ${widget.movie.genreIds != null && widget.movie.genreIds!.isNotEmpty ? widget.movie.genreIds!.map((id) => genreMap[id] ?? 'Bilinmiyor').join(', ') : 'Bilinmiyor'}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Spacer(), // Yönetmen ve IMDB puanı arasındaki boşluğu oluşturur

                  // IMDB Puanı
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber, // Sarı kutu
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.white, size: 18), // Yıldız ikonu
                            SizedBox(width: 4),
                            Text(
                              widget.movie.voteAverage
                                  .toStringAsFixed(1), // Puan
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Film Konusu
              Text(
                widget.movie.overview,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<List<Actor>>(
                      future: ActorService.fetchTopThreeActors(
                          int.parse(widget.movie.id), 10),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Bir hata oluştu.');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('Oyuncu bilgisi bulunamadı.');
                        } else {
                          final actors = snapshot.data!;
                          return Row(
                            children: actors.map((actor) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: actor.profilePhotoUrl !=
                                              null
                                          ? NetworkImage(actor.profilePhotoUrl!)
                                          : null,
                                      backgroundColor: Colors.grey,
                                      radius: 20,
                                      child: actor.profilePhotoUrl == null
                                          ? Icon(Icons.person,
                                              color: Colors.white)
                                          : null,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      actor.name,
                                      style: const TextStyle(fontSize: 8),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Herkese / Arkadaşlar

              SizedBox(height: 16),

              // Sizin İçin Alanı
            ],
          ),
        ),
      ),
    );
  }
}
