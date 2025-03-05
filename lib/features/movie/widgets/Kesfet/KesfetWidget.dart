import 'package:film_atlasi/features/movie/providers/DiscoverProvider.dart';
import 'package:film_atlasi/features/movie/widgets/Kesfet/KesfetMovieCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KesfetWidget extends StatefulWidget {
  const KesfetWidget({super.key});

  @override
  _KesfetWidgetState createState() => _KesfetWidgetState();
}

class _KesfetWidgetState extends State<KesfetWidget>
    with SingleTickerProviderStateMixin {
  // Animasyon kontrolcüsü
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

    // Animasyonu başlat
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 110, 5, 5),
              strokeWidth: 3,
            ),
          );
        }

          return RefreshIndicator( // 🔥 SAYFA AŞAĞI ÇEKİLİNCE YENİLEME
          onRefresh: () async {
            await provider.fetchAllData(); // Filmleri yeniden yükle
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),

                    // Featured Movie Carousel - Modernize edilmiş
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SizedBox(
                        height: 380,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: provider.featuredMovies.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double value = 0;
                                if (_pageController.position.haveDimensions) {
                                  value = index.toDouble() -
                                      (_pageController.page ?? 0);
                                  value = (value * 0.03).clamp(-1, 1);
                                }
                                return Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(value),
                                  alignment: Alignment.center,
                                  child: ModernFeaturedMovieCard(
                                      movie: provider.featuredMovies[index]),
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
                      itemCount: provider.categories.length,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            provider.filterMoviesByCategory(index);
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: EdgeInsets.only(right: 12),
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: provider.selectedCategoryIndex == index
                                  ? Color.fromARGB(255, 110, 5, 5)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: provider.selectedCategoryIndex == index
                                    ? Color.fromARGB(255, 110, 5, 5)
                                    : Colors.grey[700]!,
                                width: 1,
                              ),
                              boxShadow: provider.selectedCategoryIndex == index
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
                              provider.categories[index],
                              style: TextStyle(
                                color: provider.selectedCategoryIndex == index
                                    ? Colors.white
                                    : Colors.grey[400],
                                fontWeight:
                                    provider.selectedCategoryIndex == index
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
                      itemCount: provider.filteredMovies.length,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ModernTrendingMovieCard(
                            movie: provider.filteredMovies[index]);
                      },
                    ),
                  ),

                  SizedBox(height: 30),

                  // Additional Movie Sections
                  ModernMovieSection(
                      title: "Aksiyon", movies: provider.actionMovies),
                  ModernMovieSection(
                      title: "Romantik", movies: provider.romanceMovies),
                ],
              ),
            ),
          ],
          ),
        );
      },
    );
  }
}
