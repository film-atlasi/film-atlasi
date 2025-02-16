import 'dart:convert';
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/screens/ActorMoviesPage.dart';
import 'package:film_atlasi/features/movie/screens/FilmDetay.dart';
import 'package:film_atlasi/features/movie/services/ActorService.dart';
import 'package:film_atlasi/features/movie/widgets/%20PostActionsWidget%20.dart';
import 'package:film_atlasi/features/movie/widgets/FilmBilgiWidget.dart';
import 'package:film_atlasi/features/movie/widgets/OyuncuCircleAvatar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Film Post ve Kullanıcı Modeli
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';

class MoviePostCard extends StatefulWidget {
  final MoviePost moviePost;

  MoviePostCard({required this.moviePost});

  @override
  _MoviePostCardState createState() => _MoviePostCardState();
}

class _MoviePostCardState extends State<MoviePostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.white54,
              thickness: 1, // İsim üzerindeki çizgi
            ),
            Row(
              children: [
                // Kullanıcı Profil Fotoğrafı
                CircleAvatar(
                  backgroundImage: widget.moviePost.user.profilePhotoUrl != null
                      ? NetworkImage(widget.moviePost.user.profilePhotoUrl!)
                      : null,
                  backgroundColor: Colors.white,
                  radius: 20,
                ),

                const SizedBox(width: 12),
                // Kullanıcı Adı
                Text(
                  '${widget.moviePost.user.firstName ?? ''} ${widget.moviePost.user.userName ?? ''}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // İçerik Kısmı
            SizedBox(height: 10),
            Text(
              widget.moviePost.content,
              style: TextStyle(
                color: Color.fromARGB(255, 161, 1, 182),
              ),
            ),
            SizedBox(height: 10),
            const SizedBox(height: 8),
            // Film Posteri, Başlık ve Konu
            FilmBilgiWidget(
              movie: widget.moviePost.movie,
              baseImageUrl: 'https://image.tmdb.org/t/p/w500/',
            ),
            const SizedBox(height: 26),
            // Beğeni, Yorum, Kaydet İkonları
            Row(
              children: [
                // Beğeni ve Yorum İkonları Grubu

                PostActionsWidget(
                  postId: widget.moviePost.movie.id, // Firestore'daki post ID
                  initialLikes: widget.moviePost.likes, // Mevcut beğeni sayısı
                  initialComments:
                      widget.moviePost.comments, // Mevcut yorum sayısı
                ),
                const Spacer(), // İkonları sağa ve sola ayırmak için boşluk
                // Kaydet İkonu
                IconButton(
                  onPressed: () {
                    // Kaydet aksiyonu
                  },
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
