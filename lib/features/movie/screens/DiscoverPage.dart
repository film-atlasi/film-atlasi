import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keşfet'),
        backgroundColor: Colors.black,
      ),
      body: HorizontalCardList(),
    );
  }
}

class HorizontalCardList extends StatefulWidget {
  @override
  _HorizontalCardListState createState() => _HorizontalCardListState();
}

class _HorizontalCardListState extends State<HorizontalCardList> {
  final List<String> mostReadImages = [];
  final List<String> recentlyWatchedImages = [];
  final List<String> actionMovies = [];
  final movieService = MovieService();
  bool isLoading = true;

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
      });
    }
  }

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
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}')
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(context, "En Çok Okunanlar"),
          buildHorizontalList(context, mostReadImages),
          buildSectionTitle(context, "Son İzlenen Filmler"),
          buildHorizontalList(context, recentlyWatchedImages),
          buildSectionTitle(context, "Aksiyon"),
          buildHorizontalList(context, actionMovies),
        ],
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildHorizontalList(BuildContext context, List<String> images) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (images.isEmpty) {
      return SizedBox(
        height: screenHeight * 0.25,
        child: const Center(
          child: Text(
            "Henüz içerik yok",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return SizedBox(
      height: screenHeight * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            width: screenWidth * 0.6,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, color: Colors.white);
              },
            ),
          );
        },
      ),
    );
  }
}
