import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/screens/IletiPaylas.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/user/screens/UserPage.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:flutter/material.dart';

class FilmAraWidget extends StatefulWidget {
  /// Film seçildiğinde çalışacak callback fonksiyonu.
  /// Eğer callback sağlanmazsa, varsayılan olarak Iletipaylas ekranına yönlendirme yapılır.
  final void Function(Movie)? onMovieSelected;

  const FilmAraWidget({Key? key, this.onMovieSelected}) : super(key: key);

  @override
  State<FilmAraWidget> createState() => _FilmAraWidgetState();
}

class _FilmAraWidgetState extends State<FilmAraWidget> {
  final MovieService _movieService = MovieService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final movies = await _movieService.searchMovies(query);
      final users = await UserServices.searchUsers(query);
      setState(() {
        _searchResults = [...users, ...movies];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Film arama hatası: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildSearchTextField(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading)
            Center(child: const CircularProgressIndicator())
          else
            buildSearchResults()
        ],
      ),
    );
  }

//filn arama butonu
  Padding buildSearchTextField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Film ara...',
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: () => _searchMovies(_searchController.text),
          ),
        ),
        onChanged: _searchMovies,
      ),
    );
  }

  Expanded buildSearchResults() {
    return Expanded(
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final result = _searchResults[index];
          if (result is Movie) {
            return _buildMovieListTile(index, context);
          } else if (result is User) {
            return _buildUserListTile(index, context);
          }
        },
      ),
    );
  }

  ListTile _buildMovieListTile(int index, BuildContext context) {
    final movie = _searchResults[index];
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
        if (widget.onMovieSelected != null) {
          // Callback sağlanmışsa onu çalıştırıyoruz
          widget.onMovieSelected!(movie);
        } else {
          // Callback yoksa eski davranış: Iletipaylas ekranına yönlendir
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

  ListTile _buildUserListTile(int index, BuildContext context) {
    final User user = _searchResults[index];
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
            builder: (context) => UserPage(
              userUid: user.uid!,
            ),
          ),
        );
      },
    );
  }
}
