import 'package:film_atlasi/features/user/widgets/UserProfileRouter.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/movie/screens/IletiPaylas.dart';
import 'package:film_atlasi/features/movie/widgets/FilmList.dart';

class SearchResults extends StatelessWidget {
  final List<dynamic> searchResults;
  final String mode;

  const SearchResults({super.key, required this.searchResults, required this.mode});

  @override
  Widget build(BuildContext context) {
    if (searchResults.isEmpty && mode == "search") {
      return const Center(
          child: Text('Sonuç bulunamadı', style: TextStyle(color: Colors.white70)));
    }

    List<Movie> movies = [];
    List<User> users = [];

    for (var result in searchResults) {
      if (result is Movie) {
        movies.add(result);
      } else if (result is User) {
        users.add(result);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 25),
      child: Column(
        children: [
          if (users.isNotEmpty) ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 1),
              itemBuilder: (context, index) {
                return UserProfileRouter(
                    userId: users[index].uid!,
                    title: users[index].firstName!,
                    subtitle: users[index].userName,
                    profilePhotoUrl: users[index].profilePhotoUrl!);
              },
            ),
            const SizedBox(height: 16),
          ],
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return _buildMoviePoster(movies[index], context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviePoster(Movie movie, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (mode == "film_listesi") {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(14.0),
                  child: FilmList(selectedMovie: movie),
                );
              },
            );
          } else if (mode == "film_alinti") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Iletipaylas(movie: movie, isFromQuote: true),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Iletipaylas(movie: movie, isFromQuote: false),
              ),
            );
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 📌 Filmin Posteri
            movie.posterPath.isNotEmpty
                ? Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => _defaultMoviePlaceholder(),
                  )
                : _defaultMoviePlaceholder(),

            // 📌 Gradient (Alttan Yukarı Geçiş Efekti)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7), // Alt kısım siyah
                    Colors.transparent, // Üst kısım şeffaf
                  ],
                ),
              ),
            ),

            // 📌 Filmin Adı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Text(
                movie.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(offset: Offset(1, 1), blurRadius: 4, color: Colors.black),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultMoviePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey.shade800,
      child: const Center(
        child: Icon(Icons.movie, color: Colors.white70, size: 50),
      ),
    );
  }
}
