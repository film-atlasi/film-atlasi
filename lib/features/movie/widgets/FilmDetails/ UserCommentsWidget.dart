import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/user/widgets/UserProfileRouter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:film_atlasi/features/movie/widgets/RatingDisplayWidget.dart';

class UserCommentsWidget extends StatelessWidget {
  final List<MoviePost> posts;

  const UserCommentsWidget({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Text(
        'Henüz bu film hakkında paylaşım yapılmamış.',
        style: TextStyle(color: Colors.white, fontSize: 16),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kullanıcı Yorumları",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        ...posts.map((post) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: UserProfileRouter(
              userId: post.userId,
              title: post.username,
              profilePhotoUrl: post.userPhotoUrl,
              extraWidget: RatingDisplayWidget(rating: post.rating),
              trailing: Text(
                DateFormat('dd.MM.yyyy').format(post.timestamp.toDate()),
                style: TextStyle(color: Colors.white70),
              ),
              subtitle: post.content,
            ),
          );
        }),
      ],
    );
  }
}
