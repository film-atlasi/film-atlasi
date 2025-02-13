import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/screens/FilmDetay.dart';
import 'package:film_atlasi/features/movie/services/ActorService.dart';
import 'package:film_atlasi/features/movie/widgets/OyuncuCircleAvatar.dart';

class FilmBilgiWidget extends StatelessWidget {
  final Movie movie;
  final String baseImageUrl;

  const FilmBilgiWidget(
      {Key? key, required this.movie, required this.baseImageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  movie: movie,
                ),
              ),
            );
          },
          child: Container(
            width: 120,
            height: 180,
            color: Colors.red,
            child: movie.posterPath.isNotEmpty
                ? Image.network(
                    '$baseImageUrl${movie.posterPath}',
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
                movie.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                movie.overview,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
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
                          int.parse(movie.id), 5),
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
                              return OyuncuCircleAvatar(actor: actor);
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
    );
  }
}
