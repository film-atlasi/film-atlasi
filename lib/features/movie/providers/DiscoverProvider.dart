import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:flutter/material.dart';

class DiscoverProvider extends ChangeNotifier {
  final MovieService movieService = MovieService();

  bool isLoading = true;
  List<Movie> featuredMovies = [];
  List<Movie> trendingMovies = [];
  List<Movie> actionMovies = [];
  List<Movie> romanceMovies = [];
  List<Movie> horrorMovies = [];
  List<Movie> classicMovies = [];
  List<Movie> lgbtqMovies = [];
  List<Movie> netflixMovies = []; // New list for Netflix movies

  // Filtrelenmiş filmleri tutacak liste
  List<Movie> filteredMovies = [];

  int selectedCategoryIndex = 0;
  final List<String> categories = [
    'Tümü',
    'Romantik',
    'Korku',
    'Klasik',
    'LGBTQ+',
    'Netflix' // New category for Netflix movies
  ];

  DiscoverProvider() {
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      isLoading = true;
      notifyListeners();

      final results = await Future.wait([
        movieService.getTrendingMovies(),
        movieService.getTrendingSciFiMovies(),
        movieService.getRomantikKomedi(),
        movieService.getHorrorMovies(),
        movieService.getClassicMovies(),
        movieService.getLGBTQMovies(),
        movieService.getPopularMoviesOnNetflix(),
      ]);

      featuredMovies = results[0].take(5).toList();
      trendingMovies = results[0];
      actionMovies = results[1];
      romanceMovies = results[2];
      horrorMovies = results[3];
      classicMovies = results[4];
      lgbtqMovies = results[5];
      netflixMovies = results[6]; // Store Netflix movies

      filteredMovies = trendingMovies; // Başlangıçta tüm filmler

      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Hata (Veri Çekme): $e");
      isLoading = false;
      notifyListeners();
    }
  }

  // Kategori değiştiğinde filmleri filtrele
  void filterMoviesByCategory(int index) {
    selectedCategoryIndex = index;

    switch (index) {
      case 0: // Tümü
        filteredMovies = trendingMovies;
        break;
      case 1: // Romantik
        filteredMovies = romanceMovies;
        break;
      case 2: // Korku
        filteredMovies = horrorMovies;
        break;
      case 3: // Klasik
        filteredMovies = classicMovies;
        break;
      case 4: // LGBTQ+
        filteredMovies = lgbtqMovies;
        break;
      case 5: // Netflix
        filteredMovies = netflixMovies;
        break;
      default:
        filteredMovies = trendingMovies;
    }

    notifyListeners();
  }
}
