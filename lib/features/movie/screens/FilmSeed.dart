import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/movie/widgets/FilmEkle.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FilmSeedPage extends StatefulWidget {
  const FilmSeedPage({super.key});

  @override
  State<FilmSeedPage> createState() => _FilmSeedPageState();
}

class _FilmSeedPageState extends State<FilmSeedPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<MoviePost> moviePosts = [];
  bool _loading = true;
  bool _mounted = true; // Widget'ın durumunu takip etmek için

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  @override
  void dispose() {
    _mounted = false; // Widget dispose edildiğinde flag'i false yap
    super.dispose();
  }

  Future<void> fetchAllPosts() async {
    try {
      if (!_mounted) return; // Widget dispose edildiyse işlemi sonlandır

      setState(() {
        _loading = true;
      });

      // Firestore'dan posts koleksiyonunu çek
      QuerySnapshot postsSnapshot =
          await firestore.collectionGroup("posts").get();

      // Eğer widget artık ağaçta değilse, işlemi sonlandır
      if (!_mounted) return;

      // Firestore'daki alan isimlerini kontrol et ve düzelt
      List<MoviePost> fetchedPosts = [];

      for (var doc in postsSnapshot.docs) {
        // Eğer widget artık ağaçta değilse, döngüyü sonlandır
        if (!_mounted) return;

        var data = doc.data() as Map<String, dynamic>;

        // Film bilgilerini çek
        var movieDoc =
            await firestore.collection('films').doc(data['movie']).get();
        var movieData = movieDoc.data();
        var movie = Movie.fromFirebase(movieDoc);

        if (movieData != null) {
          fetchedPosts.add(MoviePost(
            firstName: data['firstName'],
            postId: doc.id,
            userId: data['userId'],
            username: data['username'],
            userPhotoUrl: data['userPhotoUrl'],
            filmId: movie.id,
            filmName: movie.title,
            filmIcerik: movie.overview,
            content: data['content'] ?? '',
            likes: data['likes'] ?? 0,
            comments: data['comments'] ?? 0,
            isQuote: data['isQuote'] ?? false,
            rating: (data['rating'] ?? 0).toDouble(),
            timestamp: data['timestamp'] as Timestamp,
          ));
        }
      }

      // Son bir kez daha kontrol et
      if (!_mounted) return;

      setState(() {
        moviePosts = fetchedPosts;
        _loading = false;
      });

      print("Çekilen post sayısı: ${moviePosts.length}");
    } catch (e) {
      print("Hata oluştu: $e");
      // Hata durumunda da mounted kontrolü yap
      if (!_mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // RefreshIndicator için de mounted kontrolü ekle
          if (!_mounted) return;
          await fetchAllPosts();
        },
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: moviePosts.length,
                itemBuilder: (context, index) {
                  final post = moviePosts[index];
                  return MoviePostCard(moviePost: post);
                },
              ),
      ),
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
