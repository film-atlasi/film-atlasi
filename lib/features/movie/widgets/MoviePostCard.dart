import 'dart:convert';
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/screens/ActorMoviesPage.dart';
import 'package:film_atlasi/features/movie/screens/FilmDetay.dart';
import 'package:film_atlasi/features/movie/services/ActorService.dart';
import 'package:film_atlasi/features/movie/widgets/OyuncuCircleAvatar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Film Post ve Kullanıcı Modeli
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';

class MoviePostCard extends StatefulWidget {
  final MoviePost moviePost;

  MoviePostCard({required this.moviePost});

  @override
  _MoviePostCardState createState() => _MoviePostCardState();
}

class _MoviePostCardState extends State<MoviePostCard> {
  final String apiKey = 'YOUR_API_KEY';
  final String baseImageUrl = 'https://image.tmdb.org/t/p/w500';
  List<Map<String, dynamic>> cast = []; // Başrol oyuncuları listesi
  List<Map<dynamic, dynamic>> allCast = []; // Başrol oyuncuları listesi

  @override
  void initState() {
    super.initState();
    fetchCast();
  }

  // TMDb API'den başrol oyuncularını çekme
  Future<void> fetchCast() async {
    final movieId = widget.moviePost.movie.id; // Filmin ID'si
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        // İlk 3 başrol oyuncusunu alıyoruz
        allCast = (data['cast'] as List<Map<dynamic, dynamic>>).toList();
        cast = (data['cast'] as List)
            .take(3)
            .map((actor) => {
                  'name': actor['name'],
                  'profile_path': actor['profile_path'],
                })
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.white54,
              thickness: 1, // İsim üzerindeki çizgi
            ),
            Row(
              children: [
                // Kullanıcı Profil Fotoğrafı
                CircleAvatar(
                  backgroundImage: widget.moviePost.user.profilePhotoUrl != null
                      ? NetworkImage(widget.moviePost.user.profilePhotoUrl!)
                      : null,
                  backgroundColor: Colors.white,
                  radius: 20,
                ),

                const SizedBox(width: 12),
                // Kullanıcı Adı
                Text(
                  '${widget.moviePost.user.firstName ?? ''} ${widget.moviePost.user.userName ?? ''}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // İçerik Kısmı
            SizedBox(height: 10),
            Text(
              widget.moviePost.content,
              style: TextStyle(
                color: Color.fromARGB(255, 161, 1, 182),
              ),
            ),
            SizedBox(height: 10),
            const SizedBox(height: 8),
            // Film Posteri, Başlık ve Konu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Film Posteri
                GestureDetector(
                  onTap: () {
                    // FilmDetay sayfasına yönlendirme
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsPage(
                          movie: widget.moviePost.movie,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 180,
                    color: Colors.red,
                    child: widget.moviePost.movie.posterPath.isNotEmpty
                        ? Image.network(
                            '$baseImageUrl${widget.moviePost.movie.posterPath}',
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              'Poster Yok',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16), // Mesafe eklemek için SizedBox
                // Film Adı ve Konu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.moviePost.movie.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.moviePost.movie.overview,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(height: 20), // Konunun altında boşluk
                      // Başrol Oyuncuları
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder<List<Actor>>(
                              future: ActorService.fetchTopThreeActors(
                                  int.parse(widget.moviePost.movie.id), 5),
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
                                      return OyuncuCircleAvatar(actor: actor,);
                                    }).toList(),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            const SizedBox(height: 18),
            // Beğeni, Yorum, Kaydet İkonları
            Row(
              children: [
                // Beğeni ve Yorum İkonları Grubu
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Beğeni aksiyonu
                      },
                      icon: const Icon(Icons.favorite_border,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 20), // İkonlar arası boşluk
                    IconButton(
                      onPressed: () {
                        // Paylaş aksiyonu
                      },
                      icon: const Icon(Icons.share, color: Colors.white),
                    ),
                    const SizedBox(width: 20), // İkonlar arası boşluk
                    IconButton(
                      onPressed: () {
                        // Yorum aksiyonu
                      },
                      icon: const Icon(Icons.comment_outlined,
                          color: Colors.white),
                    ),
                  ],
                ),
                const Spacer(), // İkonları sağa ve sola ayırmak için boşluk
                // Kaydet İkonu
                IconButton(
                  onPressed: () {
                    // Kaydet aksiyonu
                  },
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
