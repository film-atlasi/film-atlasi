import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/services/ActorService.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/movie/widgets/AddToListButton.dart';
import 'package:film_atlasi/features/movie/widgets/FilmDetails/%20UserCommentsWidget.dart';
import 'package:film_atlasi/features/movie/widgets/FilmDetails/DirectorWidget.dart';
import 'package:film_atlasi/features/movie/widgets/FilmDetails/IMDBWidget.dart';
import 'package:film_atlasi/features/movie/widgets/FilmDetails/MovieInfoWidget.dart';
import 'package:film_atlasi/features/movie/widgets/FilmDetails/PlatformWidget.dart';
import 'package:film_atlasi/features/movie/widgets/OyuncuCircleAvatar.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    getDirector();
    fetchWatchProviders();
  }

  Future<void> fetchWatchProviders() async {
    final providers =
        await MovieService().getWatchProviders(int.parse(widget.movie.id));
    setState(() {
      watchProvidersWithIcons = providers;
    });
  }

  Future<void> getDirector() async {
    final dir = await ActorService.getDirector(widget.movie.id);
    setState(() {
      director = dir;
    });
  }

  Future<List<Actor>> fetchActors() async {
    return await ActorService.fetchTopThreeActors(
        int.parse(widget.movie.id), 10);
  }

  Future<List<MoviePost>> fetchMoviePosts() async {
    final firestore = FirebaseFirestore.instance;
    List<MoviePost> posts = [];

    try {
      final querySnapshot = await firestore
          .collection('posts')
          .where('movie', isEqualTo: widget.movie.id)
          .orderBy('timestamp', descending: true)
          .get();

      for (var doc in querySnapshot.docs) {
        final userUid = doc['user'];
        final user = await UserServices.getUserByUid(userUid);

        if (user == null) continue;

        posts.add(MoviePost(
          postId: doc['postId'],
          user: user,
          movie: widget.movie,
          content: doc['content'],
          likes: doc['likes'],
          comments: doc['comments'],
          isQuote: doc["isQuote"] ?? false,
          rating: (doc["rating"] ?? 0).toDouble(),
          timestamp: doc['timestamp'] as Timestamp,
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 6, 26),
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
            // 🎬 Film Posteri
            Image.network(
              'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.error, size: 100, color: Colors.red),
            ),
            const SizedBox(height: 16),

            // 🎥 Yönetmen Bilgisi
            DirectorWidget(director: director),
            const SizedBox(height: 16),

            // 📅 Yayınlanış Tarihi ve Tür Bilgisi
            MovieInfoWidget(
              releaseDate: widget.movie.releaseDate ?? '',
              genreIds: widget.movie.genreIds,
            ),
            const SizedBox(height: 16),

            // 🌟 IMDb Puanı ve Listeye Ekle Butonu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IMDBWidget(voteAverage: widget.movie.voteAverage),
                AddToListButton(movie: widget.movie),
              ],
            ),
            const SizedBox(height: 16),

            // 📜 Film Konusu
            Text(
              widget.movie.overview,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 🎭 Oyuncular Listesi
            const Text(
              "Oyuncular",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<Actor>>(
              future: fetchActors(),
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

            // 📺 İzlenebilecek Platformlar
            PlatformWidget(watchProvidersWithIcons: watchProvidersWithIcons),
            const SizedBox(height: 16),

            // 💬 Kullanıcı Yorumları
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
