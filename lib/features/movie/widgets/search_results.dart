import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/user/widgets/UserProfileRouter.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/movie/screens/IletiPaylas.dart';
import 'package:film_atlasi/features/movie/widgets/FilmList.dart';
import 'package:film_atlasi/features/user/screens/UserPage.dart';

class SearchResults extends StatelessWidget {
  final List<dynamic> searchResults;
  final String mode; // Mode parametresi eklendi

  const SearchResults(
      {super.key, required this.searchResults, required this.mode});

  @override
  Widget build(BuildContext context) {
    if (searchResults.isEmpty && mode == "search") {
      return const Center(
        child: Text('Sonuç bulunamadı',
          style: TextStyle(color: Colors.white70)));
    }

    // Film ve kullanıcı sonuçlarını ayır
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
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 25),
      child: Column(
        children: [
          // Kullanıcılar varsa, önce onları listele
          if (users.isNotEmpty) ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Colors.grey, height: 1),
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

          // Filmler için 2 sütunlu grid
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
      clipBehavior: Clip.antiAlias, // Kenarları yuvarlamak için
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
                builder: (context) =>
                    Iletipaylas(movie: movie, isFromQuote: true),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Iletipaylas(movie: movie, isFromQuote: false),
              ),
            );
          }
        },
        child: movie.posterPath.isNotEmpty
            ? Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Icon(Icons.movie, color: Colors.white, size: 50),
                  ),
                ),
              )
            : Container(
                color: Colors.grey.shade800,
                child: const Center(
                  child: Icon(Icons.movie, color: Colors.white70, size: 50),
                ),
              ),
      ),
    );
  }
}
