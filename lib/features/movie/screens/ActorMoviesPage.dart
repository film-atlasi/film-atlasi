import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/screens/FilmDetay.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ActorMoviesPage extends StatefulWidget {
  final String actorName;
  final int actorId;

  const ActorMoviesPage({super.key, required this.actorName, required this.actorId});

  @override
  _ActorMoviesPageState createState() => _ActorMoviesPageState();
}

class _ActorMoviesPageState extends State<ActorMoviesPage> {
  final String baseImageUrl = 'https://image.tmdb.org/t/p/w500';
  final MovieService _movieService = MovieService();
  List<Movie> movies = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchActorMovies();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchActorMovies() async {
    if (isLoadingMore) return;

    setState(() => isLoadingMore = true);

    try {
      await Future.delayed(Duration(milliseconds: 500)); // UI takılmasını önler
      final fetchedMovies =
          await _movieService.getMoviesByActor(widget.actorId, currentPage);
      if (fetchedMovies.isNotEmpty) {
        setState(() {
          movies.addAll(fetchedMovies);
          currentPage++;
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 200 && !isLoadingMore) {
      fetchActorMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                  child: Text(
                    'Film bulunamadı',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: movies.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == movies.length) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final movie = movies[index];
                    return ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: '$baseImageUrl${movie.posterPath}',
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(strokeWidth: 2),
                        errorWidget: (context, url, error) => CircleAvatar(),
                      ),
                      title: Text(
                        movie.title,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white70),
                      ),
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
