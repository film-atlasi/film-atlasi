import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Kesfet(),
    );
  }
}

class Kesfet extends StatefulWidget {
  @override
  _Kesfet createState() => _Kesfet();
}

class _Kesfet extends State<Kesfet> {
  final List<String> bilimKurgu = [];
  final List<String> trendFilmler = [];
  final List<String> actionMovies = [];
  final movieService = MovieService();
  bool isLoading = true;
  String? featuredMovieImage;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    // Verilerin paralel olarak çekilmesi için `Future.wait` kullandık
    await Future.wait([
      fetchMovies(
        fetchFunction: movieService.getRomantikKomedi,
        onMoviesFetched: (movies) {
          bilimKurgu.clear();
          bilimKurgu.addAll(movies);
        },
      ),
      fetchMovies(
        fetchFunction: movieService.getTrendingMovies,
        onMoviesFetched: (movies) {
          trendFilmler.clear();
          trendFilmler.addAll(movies);
        },
      ),
      fetchMovies(
        fetchFunction: movieService.getTrendingSciFiMovies,
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
          featuredMovieImage = bilimKurgu[0];
        }
      });
    }
  }

  /// Genel bir veri çekme metodu
  Future<void> fetchMovies({
    required Future<List<Movie>> Function() fetchFunction,
    required void Function(List<String>) onMoviesFetched,
  }) async {
    try {
      final movies = await fetchFunction();
      if (mounted) {
        final validMovies = movies
            .where((movie) =>
                movie.posterPath != null && movie.posterPath.isNotEmpty)
            .map((movie) =>
                'https://image.tmdb.org/t/p/original${movie.posterPath}')
            .toList();
        onMoviesFetched(validMovies);
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
                ),
                ContentSection(
                  title: "Popüler",
                  movies: trendFilmler,
                ),
                ContentSection(
                  title: "Aksiyon",
                  movies: bilimKurgu,
                ),
                ContentSection(
                  title: "Korku",
                  movies: bilimKurgu,
                ),
                ContentSection(
                  title: "Animasyon",
                  movies: actionMovies,
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
  final List<String> movies;

  const ContentSection({
    Key? key,
    required this.title,
    required this.movies,
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
            style: TextStyle(
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
            padding: EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[900],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Image.network(
                      movies[index],
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
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
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
