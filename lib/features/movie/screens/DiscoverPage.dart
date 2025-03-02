import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/movie/screens/trailer_screen.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Durum çubuğunu şeffaf yap
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Film Atlası",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 26),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0118),
              Color(0xFF1A0E33),
            ],
          ),
        ),
        child: Kesfet(),
      ),
    );
  }
}

class Kesfet extends StatefulWidget {
  const Kesfet({super.key});

  @override
  _Kesfet createState() => _Kesfet();
}

class _Kesfet extends State<Kesfet> with SingleTickerProviderStateMixin {
  final movieService = MovieService();
  bool isLoading = true;
  List<Movie> featuredMovies = [];
  List<Movie> trendingMovies = [];
  List<Movie> actionMovies = [];
  List<Movie> romanceMovies = [];
  List<Movie> horrorMovies = [];
  List<Movie> classicMovies = [];
  List<Movie> lgbtqMovies = [];

  // Filtrelenmiş filmleri tutacak liste
  List<Movie> filteredMovies = [];

  // Animasyon kontrolcüsü
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _selectedCategoryIndex = 0;
  final List<String> categories = [
    'Tümü',
    'Romantik',
    'Korku',
    'Klasik',
    'LGBTQ+'
  ];

  final PageController _pageController = PageController(
    viewportFraction: 0.85,
    initialPage: 1,
  );

  @override
  void initState() {
    super.initState();

    // Animasyon kontrolcüsü
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    fetchAllData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchAllData() async {
    try {
      final results = await Future.wait([
        movieService.getTrendingMovies(),
        movieService.getTrendingSciFiMovies(),
        movieService.getRomantikKomedi(),
        movieService.getHorrorMovies(),
        movieService.getClassicMovies(),
        movieService.getLGBTQMovies(),
      ]);

      if (mounted) {
        setState(() {
          featuredMovies = results[0].take(5).toList();
          trendingMovies = results[0];
          actionMovies = results[1];
          romanceMovies = results[2];
          horrorMovies = results[3];
          classicMovies = results[4];
          lgbtqMovies = results[5];
          filteredMovies = trendingMovies; // Başlangıçta tüm filmler
          isLoading = false;
        });

        // Veriler yüklendikten sonra animasyonu başlat
        _animationController.forward();
      }
    } catch (e) {
      debugPrint("Hata (Veri Çekme): $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Kategori değiştiğinde filmleri filtrele
  void filterMoviesByCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;

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
        default:
          filteredMovies = trendingMovies;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 110, 5, 5),
          strokeWidth: 3,
        ),
      );
    }

    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),

              // Featured Movie Carousel - Modernize edilmiş
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  height: 380,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: featuredMovies.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 0;
                          if (_pageController.position.haveDimensions) {
                            value =
                                index.toDouble() - (_pageController.page ?? 0);
                            value = (value * 0.03).clamp(-1, 1);
                          }
                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(value),
                            alignment: Alignment.center,
                            child: ModernFeaturedMovieCard(
                                movie: featuredMovies[index]),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Category Selector - Minimalist tasarım
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Kategoriler",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              // Category Pills - Modern tasarım
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        filterMoviesByCategory(index);
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.only(right: 12),
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: _selectedCategoryIndex == index
                              ? Color.fromARGB(255, 110, 5, 5)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _selectedCategoryIndex == index
                                ? Color.fromARGB(255, 110, 5, 5)
                                : Colors.grey[700]!,
                            width: 1,
                          ),
                          boxShadow: _selectedCategoryIndex == index
                              ? [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 110, 5, 5)
                                        .withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                    offset: Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: _selectedCategoryIndex == index
                                ? Colors.white
                                : Colors.grey[400],
                            fontWeight: _selectedCategoryIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 30),

              // Most Trending Section - Minimalist başlık
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popüler Filmler",
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

              // Trending Movies Grid - Modern tasarım
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredMovies.length,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ModernTrendingMovieCard(
                        movie: filteredMovies[index]);
                  },
                ),
              ),

              SizedBox(height: 30),

              // Additional Movie Sections
              ModernMovieSection(title: "Aksiyon", movies: actionMovies),
              ModernMovieSection(title: "Romantik", movies: romanceMovies),
            ],
          ),
        ),
      ],
    );
  }
}

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
