import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/widgets/CommentPage.dart';
import 'package:film_atlasi/features/movie/widgets/LoadingWidget.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
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
   appBar: AppBar(
  backgroundColor: Colors.black,
  elevation: 0,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  title: Align(
    alignment: Alignment.centerLeft,
    child: FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(auth.FirebaseAuth.instance.currentUser?.uid) // 🔥 Şu an giriş yapan kullanıcıyı alıyoruz
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        var userData = snapshot.data!.data() as Map<String, dynamic>;
        print("Giriş yapan kullanıcı: ${userData['userName']}");

        return Text(
          "@${userData['userName'] ?? 'Bilinmiyor'}", // 🔥 Kullanıcı adını gösteriyoruz
          style: const TextStyle(color: Colors.white, fontSize: 18),
        );
      },
    ),
  ),
),


      body: Column(
        children: [
          FutureBuilder<MoviePost?>(
            future: _postFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget();
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
