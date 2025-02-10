import 'dart:convert';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/screens/FilmDetay.dart';

class ActorMoviesPage extends StatefulWidget {
  final String actorName;
  final int actorId;

  ActorMoviesPage({required this.actorName, required this.actorId});

  @override
  _ActorMoviesPageState createState() => _ActorMoviesPageState();
}

class _ActorMoviesPageState extends State<ActorMoviesPage> {
  final String baseImageUrl = 'https://image.tmdb.org/t/p/w500';
  final MovieService _movieService = MovieService();
  List<Movie> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchActorMovies();
  }

  Future<void> fetchActorMovies() async {
    try {
      final fetchedMovies =
          await _movieService.getMoviesByActor(widget.actorId);
      setState(() {
        movies = fetchedMovies;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.actorName} Filmleri'),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : movies.isEmpty
              ? Center(
                  child: Text('Film bulunamadı',
                      style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return ListTile(
                      leading: movie.posterPath != null
                          ? Image.network('$baseImageUrl${movie.posterPath}',
                              width: 50, height: 75, fit: BoxFit.cover)
                          : Icon(Icons.movie, color: Colors.white),
                      title: Text(movie.title,
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(movie.overview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white70)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsPage(movie: movie),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
