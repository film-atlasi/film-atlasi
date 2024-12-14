import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NetflixStyleHome(),
      backgroundColor: Colors.black,
    );
  }
}

class NetflixStyleHome extends StatefulWidget {
  @override
  _NetflixStyleHomeState createState() => _NetflixStyleHomeState();
}

class _NetflixStyleHomeState extends State<NetflixStyleHome> {
  final List<String> mostReadImages = [];
  final List<String> recentlyWatchedImages = [];
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
        if (mostReadImages.isNotEmpty) {
          featuredMovieImage = mostReadImages[0];
        }
      });
    }
  }

  // Existing fetch methods remain the same
  Future<void> fetchMostReadMovies() async {
    try {
      final movies = await movieService.searchMovies('Batman');
      if (mounted) {
        setState(() {
          mostReadImages.clear();
          mostReadImages.addAll(
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
      final movies = await movieService.searchMovies('Spiderman');
      if (mounted) {
        setState(() {
          recentlyWatchedImages.clear();
          recentlyWatchedImages.addAll(
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
      final movies = await movieService.searchMovies('Action');
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
      debugPrint("Hata (Aksiyon Filmleri): $e");
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
                  title: "En Çok İzlenenler",
                  movies: mostReadImages,
                ),
                ContentSection(
                  title: "Son İzlenen Filmler",
                  movies: recentlyWatchedImages,
                ),
                ContentSection(
                  title: "Aksiyon",
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
        // Featured Movie Image
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://api.themoviedb.org/3/movie/603692/images?language=en-US&include_image_language=en,null'),
              fit: BoxFit.cover,
            ),
          ),
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.8),
                Colors.black,
              ],
            ),
          ),
        ),

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
                  Text(
                    "Film Atlası",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),

        // Movie Info Overlay
        Positioned(
          bottom: 40,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Featured Movie Title",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _buildInfoChip("2024"),
                  SizedBox(width: 8),
                  _buildInfoChip("Action"),
                  SizedBox(width: 8),
                  _buildInfoChip("HD"),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.play_arrow),
                    label: Text("Oynat"),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800]?.withOpacity(0.8),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.info_outline),
                    label: Text("Daha Fazla Bilgi"),
                  ),
                ],
              ),
            ],
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
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            padding: EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              return Container(
                width: 130,
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
