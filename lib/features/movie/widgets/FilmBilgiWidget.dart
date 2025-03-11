import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/movie/widgets/FilmDetails/OyuncuCircleAvatar.dart';
import 'package:film_atlasi/features/movie/widgets/Skeletons/FilmBilgiSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/screens/FilmDetay.dart';
import 'package:film_atlasi/features/movie/services/ActorService.dart';

class FilmBilgiWidget extends StatefulWidget {
  final String movieId;
  final bool oyuncular;
  final double posterHeight;
  final Color? titleColor;

  const FilmBilgiWidget(
      {super.key,
      required this.movieId,
      this.oyuncular = true,
      this.posterHeight = 180,
      this.titleColor});

  @override
  State<FilmBilgiWidget> createState() => _FilmBilgiWidgetState();
}

class _FilmBilgiWidgetState extends State<FilmBilgiWidget> {
  Movie? movie; // late yerine nullable tanımlandı
  bool isLoading = true; // Yüklenme durumu eklendi
  final String baseImageUrl = "https://image.tmdb.org/t/p/w500/";

  @override
  void initState() {
    super.initState();
    fetchFilmData();
  }

  Future<void> fetchFilmData() async {
    try {
      var data = await MovieService().getMovieFromFireStore(widget.movieId);
      data ??= await MovieService().getMovieDetails(int.parse(widget.movieId));
      if (mounted) {
        setState(() {
          movie = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print("Hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppConstants appConstants = AppConstants(context);
    if (isLoading) {
      return FilmBilgiSkeleton(appConstants, context);
    }

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
                  movie: movie!,
                ),
              ),
            );
          },
          child: SizedBox(
            height: widget.posterHeight,
            child: movie!.posterPath.isNotEmpty
                ? Image.network(
                    '$baseImageUrl${movie!.posterPath}',
                    fit: BoxFit.fitHeight,
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
                movie!.title,
                style: TextStyle(
                    color: widget.titleColor ?? appConstants.textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                movie!.overview,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(color: appConstants.textLightColor, fontSize: 12),
              ),
              const SizedBox(height: 20), // Konunun altında boşluk

              // Başrol Oyuncuları
              widget.oyuncular
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder<List<Actor>>(
                            future: ActorService.fetchTopThreeActors(
                                int.parse(movie!.id), 5),
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
                  : SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}
