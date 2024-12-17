import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:flutter/material.dart';

class MoviePostCard extends StatelessWidget {
  final MoviePost moviePost;

  MoviePostCard({required this.moviePost});

  @override
  Widget build(BuildContext context) {
    var children = [
      ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey, 
        ),
        title: Text(moviePost.user.firstName.toString()),
        subtitle: Text(moviePost.movie.title.toString()),
        trailing: const Icon(Icons.more_vert),
      ),
      // Film postunun başlığı ve kullanıcı bilgileri
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite_border),
                AddHorizontalSpace(context, 0.01),
                Text('${moviePost.likes} begeni'),
                // Beğeni sayısı
              ],
            ),
            Row(
              children: [
                Icon(Icons.comment),
                AddHorizontalSpace(context, 0.01),
                Text('${moviePost.comments} yorum'),
                // Yorum sayısı
              ],
            ),
          ],
        ),
      ),
    ];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
