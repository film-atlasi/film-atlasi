import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/movie/screens/FilmDetay.dart';
import 'package:film_atlasi/features/movie/widgets/AddToListButton.dart';
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
    final AppConstants appConstants = AppConstants(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appConstants.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, size: 28),
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
                _buildSortSelection(appConstants),
                _buildGenreSelection(appConstants),
                _buildYearSelection(appConstants),
                _buildImdbSelection(appConstants),
              ],
            ),
          ),

          // Önceki ve Sonraki Butonları
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // Şıklar (Seçenekler) buraya zaten eklenmiş olacak

                SizedBox(
                    height:
                        30), // Seçenekler ile butonlar arasına boşluk ekledim

                // Önceki ve Sonraki Butonları
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            appConstants.backgroundColor, // Butonun rengi
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15), // Boyut büyütüldü
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _previousStep,
                      child: _currentStep > 0
                          ? Text("← Önceki", // Yazı boyutu büyütüldü
                              style: TextStyle(
                                color: appConstants.textLightColor,
                              ))
                          : SizedBox(),
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15), // Boyut büyütüldü
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _nextStep,
                      child: Text(
                        _currentStep < 3 ? "Sonraki →" : "Filmleri Getir",
                        style: TextStyle(
                          color: appConstants.textColor,
                        ), // Yazı boyutu büyütüldü
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSortSelection(AppConstants appConstants) {
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
        appConstants: appConstants);
  }

  Widget _buildGenreSelection(AppConstants appConstants) {
    return _buildQuestionPage(
        icon: Icons.movie,
        question: "Nasıl şeyler olsun?",
        options: {
          "28": "Aksiyon/Macera",
          "35": "Komedi",
          "18": "Drama",
          "27": "Gerilim/Korku",
          "14": "Fantastik" // Yeni eklenen seçenek
        },
        onSelect: (value) {
          selectedGenre = value;
          _nextStep();
        },
        appConstants: appConstants);
  }

  Widget _buildYearSelection(AppConstants appConstants) {
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
        appConstants: appConstants);
  }

  Widget _buildImdbSelection(AppConstants appConstants) {
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
        appConstants: appConstants);
  }

  Widget _buildQuestionPage(
      {required IconData icon,
      required String question,
      required Map<String, String> options,
      required Function(String) onSelect,
      required AppConstants appConstants}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
            ),
            SizedBox(height: 20),
            Text(
              question,
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ...options.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appConstants.cardColor,
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
                      style: TextStyle(
                          color: appConstants.textColor, fontSize: 18),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class MovieResultsPage extends StatelessWidget {
  final List<Movie> movies;
  MovieResultsPage({required this.movies});

  static final Map<int, String> genreMap = {
    28: "Aksiyon",
    12: "Macera",
    16: "Animasyon",
    35: "Komedi",
    80: "Suç",
    99: "Belgesel",
    18: "Dram",
    10751: "Aile",
    14: "Fantastik",
    36: "Tarih",
    27: "Korku",
    10402: "Müzik",
    9648: "Gizem",
    10749: "Romantik",
    878: "Bilim Kurgu",
    10770: "TV Filmi",
    53: "Gerilim",
    10752: "Savaş",
    37: "Western",
  };

  @override
  Widget build(BuildContext context) {
    final AppConstants appConstants = AppConstants(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Önerilen Filmler"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          // Film türlerini ID'den metne çeviriyoruz
          String genreText = movie.genreIds != null
              ? movie.genreIds!
                  .map((id) => genreMap[id] ?? "Bilinmiyor")
                  .join(", ")
              : "Tür bilinmiyor";

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: appConstants.dialogColor, // Koyu arka plan
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

                  // Film Bilgileri ve Listeye Ekleme Butonu
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Film Bilgileri
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // 🎯 Filme tıklandığında detay sayfasına yönlendirme
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MovieDetailsPage(movie: movie),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  SizedBox(height: 5),

                                  // Tür & Yıl - Güncellenmiş kısım
                                  Text(
                                    "$genreText • ${movie.releaseDate?.split("-")[0] ?? 'Bilinmiyor'}",
                                    style: TextStyle(
                                        color: appConstants.textLightColor),
                                  ),

                                  SizedBox(height: 5),

                                  // IMDb Puanı
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.amber, size: 18),
                                      SizedBox(width: 5),
                                      Text(
                                        "${movie.voteAverage}/10",
                                        style: TextStyle(
                                          color: Colors.amberAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 5),

                                  // Açıklama
                                  Text(
                                    movie.overview,
                                    style: TextStyle(
                                        color: appConstants.dividerColor),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 📌 Sağ en tarafa Listeye Ekleme Butonu (AddToListButton)
                          AddToListButton(movie: movie),
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
