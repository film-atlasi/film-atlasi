import 'package:film_atlasi/features/movie/widgets/%20PostActionsWidget%20.dart';
import 'package:film_atlasi/features/movie/widgets/FilmBilgiWidget.dart';
import 'package:film_atlasi/features/movie/widgets/PostSilmeDuzenle.dart';
import 'package:film_atlasi/features/movie/widgets/RatingDisplayWidget.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/user/screens/UserPage.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // 🔥 Kullanıcıyı profiline yönlendiren fonksiyon
// 🔥 Kullanıcıyı profiline yönlendiren fonksiyon
  void _navigateToUserProfile(BuildContext context) {
    if (widget.moviePost.user.uid != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserPage(userUid: widget.moviePost.user.uid!),
        ),
      );
    } else {
      print("Kullanıcı profiline gidilemedi, UID eksik!");
      print("🔥 Kullanıcı UID: ${widget.moviePost.user.uid}");
    }
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
                    GestureDetector(
                      onTap: () => _navigateToUserProfile(context),
                      child: CircleAvatar(
                        backgroundImage:
                            widget.moviePost.user.profilePhotoUrl != null
                                ? NetworkImage(
                                    widget.moviePost.user.profilePhotoUrl!)
                                : null,
                        backgroundColor: Colors.white,
                        radius: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Kullanıcı Adı
                    GestureDetector(
                      onTap: () => _navigateToUserProfile(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.moviePost.user.firstName ?? ''} @${widget.moviePost.user.userName ?? ''}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (widget.isOwnPost) // 🔹 Post silme düzenleme
                      PostSilmeDuzenleme(moviePost: widget.moviePost),
                  ],
                ),
                const SizedBox(height: 10),

                // ⭐️ Kullanıcının verdiği puanı gösteriyoruz
                RatingDisplayWidget(rating: widget.moviePost.rating),

                const SizedBox(height: 10),

                // 🔥 Eğer alıntı postuysa, sadece kullanıcı yorumu ve film adı gösterilecek
                if (widget.moviePost.isQuote) ...[
                  Text(
                    '"${widget.moviePost.content}"',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "- ${widget.moviePost.movie.title}",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ] else ...[
                  // Eğer normal post ise, film posteri ve detaylar gösterilecek
                  Text(
                    widget.moviePost.content,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  FilmBilgiWidget(
                    movie: widget.moviePost.movie,
                    baseImageUrl: 'https://image.tmdb.org/t/p/w500/',
                  ),
                ],

                // 🔥 Beğeni, Yorum, Kaydet İkonları
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

                // 🔥 Zaman damgasını beğeni & yorum butonlarının ALTINA ekledik
                Padding(
                  padding:
                      const EdgeInsets.only(top: 6.0), // Hafif boşluk ekledik
                  child: Text(
                    _formatTimestamp(
                        widget.moviePost.timestamp), // Tarih bilgisi
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(color: Colors.grey), // Çizgi ekleniyor
      ],
    );
  }

  // 🔥 Timestamp'i "x dakika önce" formatına çeviren fonksiyon
  String _formatTimestamp(Timestamp timestamp) {
    DateTime postTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(postTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} saniye";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} dakika";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} saat";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} gün";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} hafta";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} ay";
    } else {
      return "${(difference.inDays / 365).floor()} yıl";
    }
  }
}
