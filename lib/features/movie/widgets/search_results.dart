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
        } else if (mode == "film_alinti") {
          // 🔥 Eğer alıntı paylaşımıysa
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Iletipaylas(
                  movie: movie, isFromQuote: true), // 💡 Özel parametre ekledik
            ),
          );
        } else {
          // Normalde ileti paylaşım ekranına yönlendir
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Iletipaylas(movie: movie, isFromQuote: false),
            ),
          );
        }
      },
    );
  }

  ListTile _buildUserListTile(User user, BuildContext context) {
    return ListTile(
      leading: user.profilePhotoUrl != null && user.profilePhotoUrl!.isNotEmpty
          ? CircleAvatar(
              backgroundImage: NetworkImage(
                  user.profilePhotoUrl!), // Kullanıcının profil fotoğrafı
            )
          : const CircleAvatar(
              backgroundColor:
                  Colors.grey, // Fotoğraf yoksa sadece gri bir avatar
              child: Icon(Icons.person, color: Colors.white), // Kullanıcı ikonu
            ),
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
