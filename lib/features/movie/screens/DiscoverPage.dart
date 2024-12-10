import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Sekme sayısı
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Keşfet'),
          backgroundColor: Colors.black,
          bottom: const TabBar(
            isScrollable: true, // Sekmelerin kaydırılabilir olmasını sağlar
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Genel Bakış'),
              Tab(text: 'En Çok Okunanlar'),
              Tab(text: 'Yeni Çıkanlar'),
              Tab(text: 'En Beğenilenler'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Center(
                child: Text('Genel Bakış Sayfası')), // İlk sekme içeriği
            HorizontalCardList(), // En Çok Okunanlar
            HorizontalCardList(), // Yeni Çıkanlar
            HorizontalCardList(), // En Beğenilenler
          ],
        ),
      ),
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
  final List<String> actionmovies = [];

  final movieService = MovieService();

  @override
  void initState() {
    super.initState();
    fetchMostReadMovies();
    fetchRecentlyWatchedMovies();
  }

  void fetchMostReadMovies() async {
    final movies = await movieService.searchMovies('Batman');
    setState(() {
      mostReadImages.clear();
      mostReadImages.addAll(
        movies
            .where((movie) => movie.posterPath.isNotEmpty)
            .map(
                (movie) => 'https://image.tmdb.org/t/p/w500${movie.posterPath}')
            .toList(),
      );
    });
  }

  void fetchRecentlyWatchedMovies() async {
    final movies = await movieService.searchMovies('Spiderman');
    setState(() {
      recentlyWatchedImages.clear();
      recentlyWatchedImages.addAll(
        movies
            .where((movie) => movie.posterPath.isNotEmpty)
            .map(
                (movie) => 'https://image.tmdb.org/t/p/w500${movie.posterPath}')
            .toList(),
      );
    });
  }

  void fetchActionMovies() async {
    final movies = await movieService.searchMovies('Action');
    setState(() {
      actionmovies.clear();
      actionmovies.addAll(
        movies
            .where((movie) => movie.posterPath.isNotEmpty)
            .map(
                (movie) => 'https://image.tmdb.org/t/p/w500${movie.posterPath}')
            .toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.01,
            ),
            child: Text(
              "En Çok Okunanlar",
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          SizedBox(
            height: screenHeight * 0.25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mostReadImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: screenWidth * 0.7,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.network(
                    mostReadImages[index],
                    fit: BoxFit.cover,
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.15,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Text(
              "Son İzlenen Filmler",
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          SizedBox(
            height: screenHeight * 0.25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentlyWatchedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: screenWidth * 0.7,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.network(
                    recentlyWatchedImages[index],
                    fit: BoxFit.cover,
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.15,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Text(
              "Aksiyon",
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          SizedBox(
            height: screenHeight * 0.25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentlyWatchedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: screenWidth * 0.7,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.network(
                    recentlyWatchedImages[index],
                    fit: BoxFit.cover,
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.15,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
