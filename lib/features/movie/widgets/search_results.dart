import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/movie/screens/IletiPaylas.dart';
import 'package:film_atlasi/features/movie/widgets/FilmList.dart';
import 'package:film_atlasi/features/user/screens/UserPage.dart';

class SearchResults extends StatelessWidget {
  final List<dynamic> searchResults;
  final String mode; // Mode parametresi eklendi

  const SearchResults({Key? key, required this.searchResults, required this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final result = searchResults[index];
        if (result is Movie) {
          return _buildMovieListTile(result, context);
        } else if (result is User) {
          return _buildUserListTile(result, context);
        }
        return Container();
      },
    );
  }

  ListTile _buildMovieListTile(Movie movie, BuildContext context) {
    return ListTile(
      leading: movie.posterPath.isNotEmpty
          ? Image.network(
              'https://image.tmdb.org/t/p/w92${movie.posterPath}',
              width: 50,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.movie, color: Colors.white),
            )
          : const Icon(Icons.movie, color: Colors.white),
      title: Text(movie.title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        movie.overview.length > 50
            ? '${movie.overview.substring(0, 50)}...'
            : movie.overview,
        style: const TextStyle(color: Colors.grey),
      ),
      onTap: () {
      // 📌 Eğer mod "film_listesi" ise, aşağıdan modal açalım
       if (mode == "film_listesi") {
        
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilmList(selectedMovie: movie),
      ),
    );
  }
  else {
          // Normalde ileti paylaşım ekranına yönlendir
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Iletipaylas(movie: movie),
            ),
          );
        }
      },
    );
  }

  ListTile _buildUserListTile(User user, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text(user.userName ?? "username",
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        user.firstName ?? "first name",
        style: const TextStyle(color: Colors.grey),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserPage(userUid: user.uid!),
          ),
        );
      },
    );
  }
}
