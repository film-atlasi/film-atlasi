import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/widgets/CommentPage.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';

class PostDetailPage extends StatefulWidget {
  final String postId;
  final String filmId;

  const PostDetailPage({super.key, required this.postId, required this.filmId});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<MoviePost?> _postFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = _fetchPost();
  }

  Future<MoviePost?> _fetchPost() async {
    try {
      final postQuery = await _firestore
          .collection("films")
          .doc(widget.filmId)
          .collection('posts')
          .doc(widget.postId)
          .get();

      if (postQuery.exists) {
        return MoviePost.fromFirestore(postQuery);
      } else {
        return null;
      }
    } catch (e) {
      print("Post yüklenirken hata oluştu: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FutureBuilder<MoviePost?>(
            future: _postFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text("Gönderi bulunamadı."));
              }

              return MoviePostCard(moviePost: snapshot.data!);
            },
          ),
          Expanded(
              child: CommentPage(
                  postId: widget.postId,
                  filmId: widget.filmId,
                  isAppBar: false))
        ],
      ),
    );
  }
}
