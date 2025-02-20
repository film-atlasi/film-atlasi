import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Future<List<Movie>>? futureMovies;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() {
    setState(() {
      futureMovies = MovieService().getUpcomingMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Filmleri yüklerken hata oluştu"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Yakında çıkacak film bulunamadı"));
          }

          var movieList = snapshot.data!;

          return ListView.builder(
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              var movie = movieList[index];
              return Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Image.network(
                      movie.posterPath?.isNotEmpty == true
                          ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
                          : "https://via.placeholder.com/300x200?text=G%C3%B6rsel+Bulunamad%C4%B1",
                      height: 200,
                      width: double.infinity, // Genişliği tam kapsar
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          "https://via.placeholder.com/300x200?text=G%C3%B6rsel+Bulunamad%C4%B1",
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    ListTile(
                      title: Text(movie.title ?? "Bilinmeyen Film",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              movie.overview?.isNotEmpty == true
                                  ? movie.overview!
                                  : "Açıklama bulunmuyor",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          SizedBox(height: 5),
                          Text(
                            "Çıkış Tarihi: ${movie.releaseDate ?? "Bilinmiyor"}",
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () async {
                        if (movie.id != null) {
                          final movieUrl =
                              "https://www.themoviedb.org/movie/${movie.id}";
                          await launchUrl(Uri.parse(movieUrl));
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
