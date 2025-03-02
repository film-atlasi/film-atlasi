import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/movie/screens/trailer_screen.dart';
import 'package:flutter/material.dart';

// ÖNE ÇIKAN FİLM KARTI - Büyük kaydırılabilir kartlar için
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

// POPÜLER FİLM KARTI - Küçük kart tasarımları için
class ModernTrendingMovieCard extends StatelessWidget {
  final Movie movie;

  const ModernTrendingMovieCard({super.key, required this.movie});

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
        width: 140,
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Movie Poster
              Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[900],
                    child: Center(
                      child: Icon(Icons.broken_image, color: Colors.white54),
                    ),
                  );
                },
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),

              // Movie Info
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.white70, size: 12),
                        SizedBox(width: 4),
                        Text(
                          (movie.voteAverage * 100).toStringAsFixed(0),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      movie.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

// KATEGORİ BÖLÜMÜ - Bir başlık ve film listesini göstermek için
class ModernMovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const ModernMovieSection(
      {super.key, required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                "Tümünü Gör",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            padding: EdgeInsets.symmetric(horizontal: 20),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  // Film fragmanını getir
                  final movieService = MovieService();
                  final trailerUrl = await movieService
                      .getMovieTrailer(int.parse(movies[index].id));

                  // Trailer ekranına git
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrailerScreen(
                        trailerUrl: trailerUrl,
                        movie: movies[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movies[index].posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[900],
                          child: Center(
                            child:
                                Icon(Icons.broken_image, color: Colors.white54),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
