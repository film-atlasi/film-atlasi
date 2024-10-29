import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/screens/IletiPaylas.dart';
import 'package:flutter/material.dart';

class FilmAraWidget extends StatefulWidget {
  const FilmAraWidget({super.key});

  @override
  State<FilmAraWidget> createState() => _FilmAraWidgetState();
}

class _FilmAraWidgetState extends State<FilmAraWidget> {
  final MovieService _movieService = MovieService();
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _movies = [];
  bool _isLoading = false;

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final movies = await _movieService.searchMovies(query);
      setState(() {
        _movies = movies;
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
        title: const Text('Film Ara ve İncele',
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          buildSearchTextField(),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            buildSearchResults(),
        ],
      ),
    );
  }

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
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _searchMovies(_searchController.text),
          ),
        ),
        onSubmitted: _searchMovies,
      ),
    );
  }

  Expanded buildSearchResults() {
    return Expanded(
      child: ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          return ListTile(
            leading: movie.posterPath.isNotEmpty
                ? Image.network(
                    'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                    width: 50,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.movie, color: Colors.white),
                  )
                : const Icon(Icons.movie, color: Colors.white),
            title:
                Text(movie.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              movie.overview.length > 50
                  ? '${movie.overview.substring(0, 50)}...'
                  : movie.overview,
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Iletipaylas(movie: movie),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
