import 'package:film_atlasi/data/models/FilmPost.dart';
import 'package:flutter/material.dart';

class FilmPostCard extends StatelessWidget {
  final FilmPost filmPost;

  FilmPostCard({required this.filmPost});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.grey, // Görsel yerine gri daire
            ),
            title: Text(filmPost.user.username!),
            subtitle: Text(filmPost.film.title.toString()),
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
                    const SizedBox(width: 8),
                    Text('${filmPost.likes} begeni'),
                    // Beğeni sayısı
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.comment),
                    SizedBox(width: 8),
                    Text('${filmPost.comments} yorum'),
                    // Yorum sayısı
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
