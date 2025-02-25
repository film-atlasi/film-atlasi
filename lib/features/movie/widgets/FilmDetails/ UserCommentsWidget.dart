import 'package:film_atlasi/features/movie/models/FilmPost.dart';
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
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: post.user.profilePhotoUrl != null &&
                        post.user.profilePhotoUrl!.isNotEmpty
                    ? NetworkImage(post.user.profilePhotoUrl!)
                    : null,
                backgroundColor: Colors.grey,
                child: post.user.profilePhotoUrl == null ||
                        post.user.profilePhotoUrl!.isEmpty
                    ? Icon(Icons.person, color: Colors.white, size: 30)
                    : null,
              ),
              title: Text(
                post.user.userName ?? "Bilinmeyen Kullanıcı",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingDisplayWidget(rating: post.rating),
                  const SizedBox(height: 4),
                  Text(post.content, style: TextStyle(color: Colors.white70)),
                ],
              ),
              trailing: Text(
                DateFormat('dd MM yyyy').format(post.timestamp.toDate()),
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }),
      ],
    );
  }
}
