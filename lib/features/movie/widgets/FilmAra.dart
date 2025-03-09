import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/movie/services/search_service.dart';
import 'package:film_atlasi/features/movie/widgets/search_results.dart';
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
  final SearchService _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _searchService.search(query);
      setState(() {
        _searchResults = results;
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
    final AppConstants appConstants = AppConstants(context);
    return Scaffold(
      appBar: AppBar(
        title: buildSearchTextField(appConstants),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading)
            Center(child: const CircularProgressIndicator())
          else
            Expanded(
              child: SearchResults(
                searchResults: _searchResults,
                mode:
                    widget.mode, // Mode bilgisini SearchResults’a gönderiyoruz
              ),
            ),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Iletipaylas(movie: movie),
          ),
        );
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
      ),onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserPage(userUid: user.uid!,),
          ),
        );
      },
    );
  }
}
