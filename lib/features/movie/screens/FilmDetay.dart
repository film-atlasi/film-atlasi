import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/provider/ThemeProvider.dart';
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/movie/widgets/FilmDetails/%20UserCommentsWidget.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/services/ActorService.dart';
import 'package:film_atlasi/features/movie/widgets/FilmDetails/DirectorWidget.dart';
import 'package:film_atlasi/features/movie/widgets/FilmDetails/IMDBWidget.dart';
import 'package:film_atlasi/features/movie/widgets/FilmDetails/MovieInfoWidget.dart';
import 'package:film_atlasi/features/movie/widgets/FilmDetails/OyuncuCircleAvatar.dart';
import 'package:film_atlasi/features/movie/widgets/AddToListButton.dart';
import 'package:film_atlasi/features/movie/widgets/FilmDetails/PlatformWidget.dart';
import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Actor director =
      Actor(name: "Yönetmen Bilinmiyor", character: "", id: -1);
  Map<String, String> watchProvidersWithIcons = {};
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getDirector();
    fetchWatchProviders();
    isLoading = true;
  }

  Future<void> getDirector() async {
    final dir = await ActorService.getDirector(widget.movie.id);
    if (mounted) {
      setState(() {
        director = dir;
      });
    }
  }

  Future<void> fetchWatchProviders() async {
    final providers =
        await MovieService().getWatchProviders(int.parse(widget.movie.id));
    if (mounted) {
      setState(() {
        watchProvidersWithIcons = providers;
      });
    }
  }

  Future<List<MoviePost>> fetchMoviePosts() async {
    final firestore = FirebaseFirestore.instance;
    List<MoviePost> posts = [];

    try {
      final querySnapshot = await firestore
          .collection('films')
          .doc(widget.movie.id)
          .collection("posts")
          .orderBy('timestamp', descending: true)
          .get();

      for (var doc in querySnapshot.docs) {
        posts.add(MoviePost(
          postId: doc.id,
          userId: doc['userId'],
          firstName: doc['firstName'],
          userPhotoUrl: doc['userPhotoUrl'],
          username: doc['username'],
          filmId: widget.movie.id,
          filmName: widget.movie.title,
          filmIcerik: widget.movie.title,
          content: doc['content'],
          likes: doc['likes'],
          comments: doc['comments'],
          isQuote: doc["isQuote"] ?? false,
          rating: (doc["rating"] ?? 0).toDouble(),
          timestamp: doc['timestamp'] as Timestamp,
          isSpoiler: doc['isSpoiler'] ?? false,
        ));
      }
      return posts;
    } catch (e) {
      print("🔥 HATA: fetchMoviePosts() içinde hata oluştu: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isImageLoaded = false;
    final ThemeMode themeMode = Provider.of<ThemeProvider>(context).themeMode;
    return Scaffold(
      backgroundColor: themeMode == ThemeMode.dark
          ? widget.movie.dominantColorDark
          : widget.movie.dominantColorLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // 📌 Shimmer sadece resim yüklenene kadar gösterilecek
                if (!_isImageLoaded)
                  Shimmer.fromColors(
                    baseColor: Colors.grey[700]!,
                    highlightColor: Colors.grey[500]!,
                    child: Container(
                      width: double.infinity,
                      height: 500, // Fotoğrafın yükseklik değerini belirle
                      color: Colors.grey[700], // Arka plan için bir renk
                    ),
                  ),

                Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      // 📌 Eğer yükleme tamamlandıysa, shimmer'ı kaldır
                      Future.delayed(Duration.zero, () {
                        _isImageLoaded = true;
                      });
                      return child; // 🎯 Normal resmi göster
                    } else {
                      return const SizedBox(); // 📌 Resim yüklenirken Shimmer görünecek
                    }
                  },
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.error, size: 100, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DirectorWidget(director: director),
            const SizedBox(height: 16),
            MovieInfoWidget(
              releaseDate: widget.movie.releaseDate ?? '',
              genreIds: widget.movie.genreIds,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IMDBWidget(voteAverage: widget.movie.voteAverage),
                AddToListButton(movie: widget.movie),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.movie.overview,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "Oyuncular",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<Actor>>(
              future: ActorService.fetchTopThreeActors(
                  int.parse(widget.movie.id), 10),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text('Oyuncu bilgisi alınamadı.',
                      style: TextStyle(color: Colors.white));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text(
                    'Oyuncu bilgisi bulunamadı.',
                    style: TextStyle(color: Colors.white),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: snapshot.data!
                          .map((actor) => OyuncuCircleAvatar(actor: actor))
                          .toList(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            PlatformWidget(watchProvidersWithIcons: watchProvidersWithIcons),
            const SizedBox(height: 16),
            FutureBuilder<List<MoviePost>>(
              future: fetchMoviePosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text('Bir hata oluştu.',
                      style: TextStyle(color: Colors.white));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text(
                    'Henüz bu film hakkında paylaşım yapılmamış.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  );
                } else {
                  return UserCommentsWidget(posts: snapshot.data!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
