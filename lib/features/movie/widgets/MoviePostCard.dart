import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:flutter/material.dart';

class MoviePostCard extends StatelessWidget {
  final MoviePost moviePost;

  MoviePostCard({required this.moviePost});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kullanıcı Profil Fotoğrafı
            CircleAvatar(
              backgroundImage: moviePost.user.profilePhotoUrl != null
                  ? NetworkImage(moviePost.user.profilePhotoUrl!)
                  : null,
              backgroundColor: Colors.red,
              radius: 24,
            ),
            const SizedBox(width: 12),
            // Kullanıcı Adı ve Film İçeriği
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kullanıcı Adı
                  Text(
                    '${moviePost.user.firstName ?? ''} ${moviePost.user.surname ?? ''} @${moviePost.user.userName ?? ''}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Kullanıcı İçeriği
                  Text(
                    moviePost.content,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Film Detayları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Film Posteri
                      Container(
                        color: Colors.grey,
                        width: 100,
                        child: moviePost.movie.posterPath.isNotEmpty
                            ? Image.network(
                                'https://image.tmdb.org/t/p/w500${moviePost.movie.posterPath}',
                                fit: BoxFit.fitWidth,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      'Hata: Resim yüklenemedi',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  'film posteri',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: 8),

                      // Film Adı ve Konusu
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            moviePost.movie.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              moviePost.movie.overview,
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 12),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
