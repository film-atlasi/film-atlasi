import 'package:film_atlasi/features/movie/services/search_service.dart';
import 'package:film_atlasi/features/movie/widgets/search_results.dart';
import 'package:flutter/material.dart';

class FilmAraWidget extends StatefulWidget {
  final String mode; // Yeni eklenen parametre

  const FilmAraWidget({super.key, required this.mode});

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
            Expanded(
              child: SearchResults(
                searchResults: _searchResults,
                mode: widget.mode, // Mode bilgisini SearchResults’a gönderiyoruz
              ),
            ),
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
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: () => _searchMovies(_searchController.text),
          ),
        ),
        onChanged: _searchMovies,
      ),
    );
  }
}
