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

      // Eğer widget artık ağaçta değilse, işlemi sonlandır
      if (!_mounted) return;

      final moviesSnapshot = await firestore.collection('films').get();

      List<MoviePost> allPosts = [];

      for (var movieDoc in moviesSnapshot.docs) {
        final movieId = movieDoc.id;

        final querySnapshot = await firestore
            .collection('films')
            .doc(movieId)
            .collection('posts')
            .get(); // orderBy kullanmıyoruz, çünkü bazen indeks hatası verebilir

        allPosts.addAll(
            querySnapshot.docs.map((doc) => MoviePost.fromFirestore(doc)));
      }

      // Son bir kez daha kontrol et
      if (!_mounted) return;

      setState(() {
        moviePosts = allPosts;
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
