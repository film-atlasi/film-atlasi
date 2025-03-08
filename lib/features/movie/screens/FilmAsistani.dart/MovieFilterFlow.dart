import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/screens/FilmAsistani.dart/widget/MovieIntroPage.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';

class MovieFilterFlow extends StatefulWidget {
  @override
  _MovieFilterFlowState createState() => _MovieFilterFlowState();
}

class _MovieFilterFlowState extends State<MovieFilterFlow> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  String selectedSort = "popularity.desc";
  String selectedGenre = "28"; // Varsayılan: Aksiyon
  int selectedYear = 2023;
  double imdbRating = 6.0;

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _pageController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      // Kullanıcı seçimleri tamamladı, sonuçları getir
      _fetchMovies();
    }
  }

  Future<void> _fetchMovies() async {
    final MovieService movieService = MovieService();
    List<Movie> movies = await movieService.fetchFilteredMovies(
      minImdb: imdbRating,
      genre: selectedGenre,
      country: "US",
      year: selectedYear,
      minDuration: 90,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieResultsPage(movies: movies),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MovieIntroPage()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildSortSelection(),
                _buildGenreSelection(),
                _buildYearSelection(),
                _buildImdbSelection(),
              ],
            ),
          ),

          // Önceki ve Sonraki Butonları
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  onPressed: _previousStep,
                  child: Text(
                    "← Önceki Soru",
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  onPressed: _nextStep,
                  child: Text(
                    _currentStep < 3 ? "Sonraki Soru →" : "Filmleri Getir",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortSelection() {
    return _buildQuestionPage(
      icon: Icons.bar_chart,
      question: "Neye göre sıralansın?",
      options: {
        "popularity.desc": "Popülerlik",
        "release_date.desc": "Yeni Çıkanlar",
        "vote_count.desc": "En Çok Oy Alanlar",
        "vote_average.desc": "Puan (Yüksekten Düşüğe)"
      },
      onSelect: (value) {
        selectedSort = value;
        _nextStep();
      },
    );
  }

  Widget _buildGenreSelection() {
    return _buildQuestionPage(
      icon: Icons.movie,
      question: "Nasıl şeyler olsun?",
      options: {
        "28": "Aksiyon/Macera",
        "35": "Komedi",
        "18": "Drama",
        "27": "Gerilim/Korku"
      },
      onSelect: (value) {
        selectedGenre = value;
        _nextStep();
      },
    );
  }

  Widget _buildYearSelection() {
    return _buildQuestionPage(
      icon: Icons.date_range,
      question: "Hangi yıllardan olsun?",
      options: {
        "2022": "Yeni Çıkanlar (Son 2 Yıl)",
        "2010": "2010'lu Yıllar",
        "2000": "2000'li Yıllar",
        "1999": "Klasikler (2000 Öncesi)"
      },
      onSelect: (value) {
        selectedYear = int.parse(value);
        _nextStep();
      },
    );
  }

  Widget _buildImdbSelection() {
    return _buildQuestionPage(
      icon: Icons.star,
      question: "IMDb puanı nasıl olsun?",
      options: {
        "8.0": "En iyiler (8+)",
        "7.0": "İyi Olanlar (7+)",
        "6.0": "Ortalama Üstü (6+)",
        "0": "Farketmez"
      },
      onSelect: (value) {
        imdbRating = double.parse(value);
        _nextStep();
      },
    );
  }

  Widget _buildQuestionPage({
    required IconData icon,
    required String question,
    required Map<String, String> options,
    required Function(String) onSelect,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 20),
            Text(
              question,
              style: TextStyle(color: Colors.white, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ...options.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  onPressed: () => onSelect(entry.key),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      entry.value,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class MovieResultsPage extends StatelessWidget {
  final List<Movie> movies;
  MovieResultsPage({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Önerilen Filmler"),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900], // Koyu arka plan
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Film Afişi
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://image.tmdb.org/t/p/w200${movie.posterPath}",
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(width: 12), // Boşluk

                  // Film Bilgileri
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 5),

                          // Tür & Yıl
                          Text(
                            "Dizi • ${movie.genreIds?.join(", ")} • ${movie.releaseDate?.split("-")[0] ?? 'Bilinmiyor'}",
                            style: TextStyle(color: Colors.grey[400]),
                          ),

                          SizedBox(height: 5),

                          // IMDb Puanı
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow, size: 18),
                              SizedBox(width: 5),
                              Text(
                                "${movie.voteAverage}/10",
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 5),

                          // Açıklama
                          Text(
                            movie.overview,
                            style: TextStyle(color: Colors.grey[400]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
