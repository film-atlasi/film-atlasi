import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/movie/widgets/FilmEkle.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FilmSeedPage extends StatefulWidget {
  FilmSeedPage({super.key});

  @override
  State<FilmSeedPage> createState() => _FilmSeedPageState();
}

class _FilmSeedPageState extends State<FilmSeedPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _loading = false;

  late List<MoviePost> moviePosts = [];

  @override
  void initState() {
    super.initState();
    _loading = true;
    fetchAllPosts();
    _loading = false;
  }

  Future<void> fetchAllPosts() async {
    try {
      QuerySnapshot postsSnapshot = await firestore
          .collection("posts")
          .orderBy('timestamp', descending: true)
          .get();
      List<Map<String, dynamic>> posts = postsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      Set<String> filmIds =
          posts.map((post) => post['movie'] as String).toSet();
      QuerySnapshot filmsSnapshot = await firestore
          .collection('films')
          .where(FieldPath.documentId, whereIn: filmIds.toList())
          .get();
      Map<String, Map<String, dynamic>> films = {
        for (var doc in filmsSnapshot.docs)
          doc.id: doc.data() as Map<String, dynamic>
      };
      Set<String> userIds = posts.map((post) => post['user'] as String).toSet();
      QuerySnapshot usersSnapshot = await firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds.toList())
          .get();

      Map<String, Map<String, dynamic>> users = {
        for (var doc in usersSnapshot.docs)
          doc.id: doc.data() as Map<String, dynamic>
      };

      setState(() {
        moviePosts = posts.map((post) {
          String filmId = post['movie'];
          String userId = post['user'];

          return MoviePost(
            postId: post["postId"],
            user: User.fromMap(users[userId] ?? {}),
            movie: Movie.fromMap(films[filmId] ?? {}),
            likes: post["likes"],
            comments: post["comments"],
            content: post["content"],
            isQuote: post["isQuote"] ?? false,
            rating: (post["rating"] ?? 0)
                .toDouble(), // ⭐️ Burada rating değerini alıyoruz!
            timestamp: post["timestamp"],
          );
        }).toList();
      });
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => fetchAllPosts(),
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: moviePosts.length,
                itemBuilder: (context, index) {
                  final post = moviePosts[index];
                  return MoviePostCard(moviePost: post);
                  // Film postlarını listeliyoruz
                },
              ),
      ),
      //  floatingActionButton: buildFloatingActionButton(context),
    );
  }

  // FloatingActionButton buildFloatingActionButton(BuildContext context) {
  //   return FloatingActionButton(
  //     shape: CircleBorder(),
  //     onPressed: () {
  //       showModalBottomSheet(
  //         // Modal açılır
  //         context: context, // Context
  //         builder: (BuildContext context) {
  //           // Modal içeriği
  //           return FilmEkleWidget(); // Film ekleme widget'ı
  //         },
  //       );
  //     },
  //     child: Icon(Icons.add),
  //   );
  // }
}
