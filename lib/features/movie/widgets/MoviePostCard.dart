import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/widgets/%20PostActionsWidget%20.dart';
import 'package:film_atlasi/features/movie/widgets/FilmBilgiWidget.dart';
import 'package:film_atlasi/features/movie/widgets/PostSilmeDuzenle.dart';
import 'package:film_atlasi/features/movie/widgets/RatingDisplayWidget.dart';
import 'package:film_atlasi/features/movie/widgets/SpoilerWidget.dart';
import 'package:film_atlasi/features/user/services/KaydetServices.dart';
import 'package:film_atlasi/features/user/widgets/UserProfileRouter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoviePostCard extends StatefulWidget {
  final MoviePost moviePost;
  final bool isOwnPost;

  const MoviePostCard(
      {super.key, required this.moviePost, this.isOwnPost = false});

  @override
  _MoviePostCardState createState() => _MoviePostCardState();
}

class _MoviePostCardState extends State<MoviePostCard> {
  @override
  void initState() {
    super.initState();
  }

  Stream<DocumentSnapshot> isKaydedildi(String postId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("kaydedilenler")
        .doc(postId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final KaydetServices _kaydetServices = KaydetServices();
    return Container(
      child: GestureDetector(
        onLongPress: () {
          if (widget.isOwnPost) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: PostSilmeDuzenleme(moviePost: widget.moviePost),
              ),
            );
          }
        },
        child: Column(
          children: [
            Card(
              color: AppConstants.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserProfileRouter(
                      title: widget.moviePost.firstName,
                      profilePhotoUrl: widget.moviePost.userPhotoUrl,
                      subtitle: widget.moviePost.username,
                      userId: widget.moviePost.userId,
                    ),

                    const SizedBox(height: 10),

                    // ⭐️ Kullanıcının verdiği puanı gösteriyoruz

                    // 🔥 Eğer alıntı postuysa, sadece kullanıcı yorumu ve film adı gösterilecek
                    if (widget.moviePost.isQuote) ...[
                      Text(
                        '"${widget.moviePost.content}"',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: AppConstants.textColor,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "- ${widget.moviePost.filmName}",
                        style: TextStyle(
                            color: AppConstants.textLightColor, fontSize: 14),
                      ),
                    ] else ...[
                      RatingDisplayWidget(rating: widget.moviePost.rating),

                      const SizedBox(height: 10),
                      // Eğer normal post ise, film posteri ve detaylar gösterilecek
                      widget.moviePost.isSpoiler
                          ? SpoilerWidget(content: widget.moviePost.content)
                          : Text(widget.moviePost.content,
                              style: TextStyle(color: AppConstants.textColor)),
                      const SizedBox(height: 10),
                      FilmBilgiWidget(
                        movieId: widget.moviePost.filmId,
                      ),
                    ],
                    AddVerticalSpace(context, 0.01),
                    // 🔥 Beğeni, Yorum, Kaydet İkonları
                    Row(
                      children: [
                        PostActionsWidget(
                          filmId: widget.moviePost.filmId,
                          postId:
                              widget.moviePost.postId, // Firestore'daki post ID
                          initialLikes:
                              widget.moviePost.likes, // Mevcut beğeni sayısı
                          initialComments:
                              widget.moviePost.comments, // Mevcut yorum sayısı
                        ),
                        const Spacer(),
                        StreamBuilder(
                          stream: isKaydedildi(widget.moviePost.postId),
                          builder: (context, snapshot) {
                            final bool kaydedildi =
                                snapshot.hasData && snapshot.data!.exists;
                            return IconButton(
                              onPressed: () async {
                                if (kaydedildi) {
                                  await _kaydetServices.postKaydetKaldir(
                                      widget.moviePost.postId, context);
                                } else {
                                  await _kaydetServices.postKaydet(
                                      widget.moviePost.postId,
                                      widget.moviePost.filmId,
                                      context);
                                }
                              },
                              icon: Icon(
                                kaydedildi
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: kaydedildi
                                    ? AppConstants.textColor
                                    : AppConstants.textLightColor,
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // 🔥 Zaman damgasını beğeni & yorum butonlarının ALTINA ekledik
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 6.0), // Hafif boşluk ekledik
                      child: Text(
                        _formatTimestamp(
                            widget.moviePost.timestamp), // Tarih bilgisi
                        style: TextStyle(
                            color: AppConstants.textLightColor, fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: AppConstants.textLightColor), // Çizgi ekleniyor
          ],
        ),
      ),
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
