import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/movie/screens/trailer_screen.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final movieService = MovieService(); // MovieService nesnesini oluşturduk

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Film Atlası",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const FilmAraWidget(mode: "film_incele")),
              );
            },
          ),
        ],
      ),
      body: Kesfet(movieService: movieService),
    );
  }
}

class Kesfet extends StatefulWidget {
  final MovieService movieService;

  const Kesfet({Key? key, required this.movieService}) : super(key: key);

  @override
  _Kesfet createState() => _Kesfet();
}

class _Kesfet extends State<Kesfet> {
  final List<Movie> bilimKurgu = [];
  final List<Movie> trendFilmler = [];
  final List<Movie> actionMovies = [];
  bool isLoading = true;
  String? featuredMovieImage;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    await Future.wait([
      fetchMovies(
        fetchFunction: widget.movieService.getRomantikKomedi,
        onMoviesFetched: (movies) {
          bilimKurgu.clear();
          bilimKurgu.addAll(movies);
        },
      ),
      fetchMovies(
        fetchFunction: widget.movieService.getTrendingMovies,
        onMoviesFetched: (movies) {
          trendFilmler.clear();
          trendFilmler.addAll(movies);
        },
      ),
      fetchMovies(
        fetchFunction: widget.movieService.getTrendingSciFiMovies,
        onMoviesFetched: (movies) {
          actionMovies.clear();
          actionMovies.addAll(movies);
        },
      ),
    ]);

    if (mounted) {
      setState(() {
        isLoading = false;
        if (bilimKurgu.isNotEmpty) {
          featuredMovieImage = bilimKurgu[0].posterPath;
        }
      });
    }
  }

  Future<void> fetchMovies({
    required Future<List<Movie>> Function() fetchFunction,
    required void Function(List<Movie>) onMoviesFetched,
  }) async {
    try {
      final movies = await fetchFunction();
      if (mounted) {
        onMoviesFetched(movies);
      }
    } catch (e) {
      debugPrint("Hata (Veri Çekme): $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.red),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                ContentSection(
                  title: "Trends",
                  movies: actionMovies,
                  movieService: widget.movieService,
                ),
                ContentSection(
                  title: "Popüler",
                  movies: trendFilmler,
                  movieService: widget.movieService,
                ),
                ContentSection(
                  title: "Aksiyon",
                  movies: bilimKurgu,
                  movieService: widget.movieService,
                ),
                ContentSection(
                  title: "Korku",
                  movies: bilimKurgu,
                  movieService: widget.movieService,
                ),
                ContentSection(
                  title: "Animasyon",
                  movies: actionMovies,
                  movieService: widget.movieService,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ContentSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final MovieService movieService;

  const ContentSection({
    Key? key,
    required this.title,
    required this.movies,
    required this.movieService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              final Movie movie = movies[index];
              return GestureDetector(
                onTap: () async {
                  final Movie movie = movies[index];
                  final movieId = int.parse(movie.id);
                  final trailerUrl =
                      await movieService.getMovieTrailer(movieId);

                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrailerScreen(
                        trailerUrl:
                            trailerUrl, // Eğer fragman bulunamazsa IMDB linki dönebilir
                        movie: movie,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[900],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/original${movie.posterPath}',
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child:
                                Icon(Icons.broken_image, color: Colors.white54),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withAlpha((0.8 * 255).toInt()),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
