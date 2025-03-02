import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/movie/screens/trailer_screen.dart';
import 'package:flutter/material.dart';

class ModernFeaturedMovieCard extends StatelessWidget {
  final Movie movie;

  const ModernFeaturedMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Film fragmanını getir
        final movieService = MovieService();
        final trailerUrl =
            await movieService.getMovieTrailer(int.parse(movie.id));

        // Trailer ekranına git
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrailerScreen(
              trailerUrl: trailerUrl,
              movie: movie,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Movie Poster
              Hero(
                tag: 'movie_${movie.id}',
                child: Image.network(
                  'https://image.tmdb.org/t/p/original${movie.posterPath}',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: Center(
                        child: Icon(Icons.broken_image,
                            color: Colors.white54, size: 50),
                      ),
                    );
                  },
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: [0.5, 0.8, 1.0],
                  ),
                ),
              ),

              // Play Button
              Center(
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 110, 5, 5).withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 110, 5, 5).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),

              // Movie Info
              Positioned(
                bottom: 25,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 14),
                              SizedBox(width: 4),
                              Text(
                                movie.voteAverage.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "2h 15m",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
