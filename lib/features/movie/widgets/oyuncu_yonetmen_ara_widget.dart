import 'package:film_atlasi/features/movie/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/services/oyuncu_yonetmen_search_service.dart'; // Ensure this file exists or update the path
import 'package:film_atlasi/features/movie/widgets/person_search_results.dart';

class OyuncuYonetmenAraWidget extends StatefulWidget {
  final String mode; // "list" veya "grid" olabilir

  const OyuncuYonetmenAraWidget({super.key, required this.mode});

  @override
  State<OyuncuYonetmenAraWidget> createState() =>
      _OyuncuYonetmenAraWidgetState();
}

class _OyuncuYonetmenAraWidgetState extends State<OyuncuYonetmenAraWidget> {
  final OyuncuYonetmenSearchService _searchService =
      OyuncuYonetmenSearchService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchPeople(String query) async {
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final results = await _searchService.search(query);
      setState(() => _searchResults = results);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arama hatası: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: buildSearchTextField()),
      body: Column(
        children: [
          if (_isLoading)
            LoadingWidget()
          else
            Expanded(
              child: PersonSearchResults(
                searchResults: _searchResults,
                mode: widget.mode,
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
        decoration: InputDecoration(
          hintText: 'Oyuncu veya yönetmen ara...',
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _searchPeople(_searchController.text),
          ),
        ),
        onChanged: _searchPeople,
      ),
    );
  }
}
