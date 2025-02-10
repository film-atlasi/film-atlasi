import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FilmListScreen extends StatefulWidget {
  final int movieId;

  const FilmListScreen({super.key, required this.movieId});

  @override
  State<FilmListScreen> createState() => _FilmListScreenState();
}

class _FilmListScreenState extends State<FilmListScreen> {
  final List<Movie> _myFilmList = [];

  void _handleMovieSelected(Movie movie) {
    if (!_myFilmList.contains(movie)) {
      setState(() {
        _myFilmList.add(movie);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${movie.title} film listesine eklendi!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${movie.title} zaten listede!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Film Listesi')),
      body: Column(
        children: [
          Expanded(
            child: FilmAraWidget(
              onMovieSelected: _handleMovieSelected,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _myFilmList.length,
              itemBuilder: (context, index) {
                final movie = _myFilmList[index];
                return ListTile(
                  title: Text(movie.title),
                  leading: movie.posterPath.isNotEmpty
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                          width: 50,
                        )
                      : const Icon(Icons.movie),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
