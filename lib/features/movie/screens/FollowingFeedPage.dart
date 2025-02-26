import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowingFeedPage extends StatefulWidget {
  @override
  _FollowingFeedPageState createState() => _FollowingFeedPageState();
}

class _FollowingFeedPageState extends State<FollowingFeedPage> {
  late Future<List<MoviePost>> _followingPosts;

  @override
  void initState() {
    super.initState();
    final userUid = FirebaseAuth.instance.currentUser?.uid ?? "";
    _followingPosts = UserServices.getFollowingUsersPosts(userUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MoviePost>>(
        future: _followingPosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Bir hata oluştu: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Henüz kimseyi takip etmiyorsun."));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return MoviePostCard(moviePost: posts[index]);
            },
          );
        },
      ),
    );
  }
}
