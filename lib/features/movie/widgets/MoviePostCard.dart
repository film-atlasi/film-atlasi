import 'package:film_atlasi/features/movie/widgets/%20PostActionsWidget%20.dart';
import 'package:film_atlasi/features/movie/widgets/FilmBilgiWidget.dart';
import 'package:film_atlasi/features/movie/widgets/PostSilmeDuzenle.dart';
import 'package:flutter/material.dart';

import 'package:film_atlasi/features/movie/models/FilmPost.dart';

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
                      backgroundImage: widget.moviePost.user.profilePhotoUrl !=
                              null
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
                    Spacer(),
                    if (widget.isOwnPost) // 🔹 Post silme düzenleme
                      PostSilmeDuzenleme(moviePost: widget.moviePost),
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
                  Text(widget.moviePost.content,
                      style: TextStyle(color: Colors.white)),
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
                      postId: widget.moviePost.postId, // Firestore'daki post ID
                      initialLikes:
                          widget.moviePost.likes, // Mevcut beğeni sayısı
                      initialComments:
                          widget.moviePost.comments, // Mevcut yorum sayısı
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // Kaydet aksiyonu
                      },
                      icon: const Icon(Icons.bookmark_border,
                          color: Colors.white),
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
