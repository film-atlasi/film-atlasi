import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:flutter/material.dart';

class FilmKutusu extends StatefulWidget {
  final String userUid;
  const FilmKutusu({super.key, required this.userUid});

  @override
  State<FilmKutusu> createState() => _FilmKutusuState();
}

class _FilmKutusuState extends State<FilmKutusu> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserServices.getAllUsersPosts(widget.userUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Bir sorun oluştu: ${snapshot.error}",
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          final posts = snapshot.data;
          return ListView.builder(
            itemCount: posts!.length,
            itemBuilder: (context, index) => MoviePostCard(
              moviePost: posts[index],
              isOwnPost: true,
            ),
          );
        }
      },
    );
  }
}
