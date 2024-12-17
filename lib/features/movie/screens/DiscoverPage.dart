import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    await fetchMostReadMovies();
    await fetchRecentlyWatchedMovies();
    await fetchActionMovies();
    if (mounted) {
      setState(() {
        isLoading = false;
        if (bilimKurgu.isNotEmpty) {
          featuredMovieImage = bilimKurgu[0];
        }
      });
    }
  }

  // Existing fetch methods remain the same
  Future<void> fetchMostReadMovies() async {
    try {
      final movies = await movieService.getRomantikKomedi();
      if (mounted) {
        setState(() {
          bilimKurgu.clear();
          bilimKurgu.addAll(
            movies
                .where((movie) =>
                    movie.posterPath != null && movie.posterPath.isNotEmpty)
                .map((movie) =>
                    'https://image.tmdb.org/t/p/original${movie.posterPath}')
                .toList(),
          );
        });
      }
    } catch (e) {
      debugPrint("Hata (En Çok Okunanlar): $e");
    }
  }

  Future<void> fetchRecentlyWatchedMovies() async {
    try {
      final movies = await movieService.getTrendingMovies();
      if (mounted) {
        setState(() {
          trendFilmler.clear();
          trendFilmler.addAll(
            movies
                .where((movie) =>
                    movie.posterPath != null && movie.posterPath.isNotEmpty)
                .map((movie) =>
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}')
                .toList(),
          );
        });
      }
    } catch (e) {
      debugPrint("Hata (Son İzlenen Filmler): $e");
    }
  }

  Future<void> fetchActionMovies() async {
    try {
      final movies = await movieService.getTrendingSciFiMovies();
      if (mounted) {
        setState(() {
          actionMovies.clear();
          actionMovies.addAll(
            movies
                .where((movie) =>
                    movie.posterPath != null && movie.posterPath.isNotEmpty)
                .map((movie) =>
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}')
                .toList(),
          );
        });
      }
    } catch (e) {
      debugPrint("Hata (Trend filmler): $e");
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
        // Featured Movie Section with Integrated AppBar
        SliverToBoxAdapter(
          child: FeaturedMovieHeader(
            imageUrl: featuredMovieImage,
          ),
        ),

        // Content Sections
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

class FeaturedMovieHeader extends StatelessWidget {
  final String? imageUrl;

  const FeaturedMovieHeader({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Arka Plan Rengi veya Görseli
        Container(),
        // Custom AppBar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Başlık
                  Text(
                    "Film Atlası",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Arama Butonu
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      print("Arama butonuna tıklandı!");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        // Örnek bir içerik alanı
        Positioned.fill(
          top: 100, // AppBar'ın altına yerleşecek
          child: Center(
            child: Text(
              "Film içerikleri burada gösterilecek",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withOpacity(0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
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
