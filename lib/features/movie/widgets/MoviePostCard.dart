import 'dart:convert';
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/screens/ActorMoviesPage.dart';
import 'package:film_atlasi/features/movie/screens/FilmDetay.dart';
import 'package:film_atlasi/features/movie/services/ActorService.dart';
import 'package:film_atlasi/features/movie/widgets/%20PostActionsWidget%20.dart';
import 'package:film_atlasi/features/movie/widgets/FilmBilgiWidget.dart';
import 'package:film_atlasi/features/movie/widgets/OyuncuCircleAvatar.dart';
import 'package:film_atlasi/features/movie/widgets/PostSilmeDuzenle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Film Post ve Kullanıcı Modeli
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore kullanıyorsan ekle

class MoviePostCard extends StatefulWidget {
  final MoviePost moviePost;
  final bool isOwnPost;

  MoviePostCard({required this.moviePost, this.isOwnPost = false});

  @override
  _MoviePostCardState createState() => _MoviePostCardState();
}

class _MoviePostCardState extends State<MoviePostCard> {
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.moviePost.content;
  }


  @override
  Widget build(BuildContext context) {

    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: Colors.white54, thickness: 1),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.moviePost.user.profilePhotoUrl != null
                      ? NetworkImage(widget.moviePost.user.profilePhotoUrl!)
                      : null,
                  backgroundColor: Colors.white,
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  '${widget.moviePost.user.firstName ?? ''} ${widget.moviePost.user.userName ?? ''}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (widget.isOwnPost) // 🔹 Post silme düzenleme
                  PostSilmeDuzenleme(moviePost: widget.moviePost),
              ],
            ),
            SizedBox(height: 10),
            Text(
              widget.moviePost.content,
              style: TextStyle(
                color: Color.fromARGB(255, 161, 1, 182),
              ),
            ),
            SizedBox(height: 10),
            FilmBilgiWidget(
              movie: widget.moviePost.movie,
              baseImageUrl: 'https://image.tmdb.org/t/p/w500/',
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                PostActionsWidget(
                  postId: widget.moviePost.movie.id,
                  initialLikes: widget.moviePost.likes,
                  initialComments: widget.moviePost.comments,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // Kaydet aksiyonu
                  },
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),

    return Column(
      children: [
        Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 10),

                // 🔥 Eğer alıntı postuysa, sadece kullanıcı yorumu ve film adı gösterilecek
                if (widget.moviePost.isQuote) ...[
                  Text(
                    '"${widget.moviePost.content}"',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "- ${widget.moviePost.movie.title}",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ] else ...[
                  // Eğer normal post ise, film posteri ve detaylar gösterilecek
                  Text(widget.moviePost.content, style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  FilmBilgiWidget(
                    movie: widget.moviePost.movie,
                    baseImageUrl: 'https://image.tmdb.org/t/p/w500/',
                  ),
                ],

                // 🔥 Beğeni, Yorum, Kaydet İkonları (Her iki post türü için de)
                Row(
                  children: [
                    PostActionsWidget(
                      postId: widget.moviePost.postId,  // Firestore'daki post ID
                      initialLikes: widget.moviePost.likes, // Mevcut beğeni sayısı
                      initialComments: widget.moviePost.comments, // Mevcut yorum sayısı
                    ),
                    const Spacer(),
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
        ),
        Divider(color: Colors.grey), // Çizgi ekleniyor
      ],
    );
  }

}
