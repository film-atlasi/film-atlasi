import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/services/ActorService.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/movie/widgets/OyuncuCircleAvatar.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  MovieDetailsPage({required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Actor director = Actor(name: "name", character: "character", id: -1);
  List<String> watchProviders = [];

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

        if (user == null) {
          print("❌ Kullanıcı bulunamadı: $userUid");
          continue;
        }

        print(
            "👤 Kullanıcı: ${user.userName} - Fotoğraf URL: ${user.profilePhotoUrl}");

        posts.add(MoviePost(
          postId: doc['postId'],
          user: user,
          movie: widget.movie,
          content: doc['content'],
          likes: doc['likes'],
          comments: doc['comments'],
          isQuote: doc["isQuote"] ?? false,
        ));
      }
      return posts;
    } catch (e, stackTrace) {
      print("🔥 HATA: fetchMoviePosts() içinde hata oluştu: $e");
      print(stackTrace);
      return [];
    }
  }

  final Map<int, String> genreMap = {
    28: "Aksiyon",
    12: "Macera",
    16: "Animasyon",
    35: "Komedi",
    80: "Suç",
    99: "Belgesel",
    18: "Dram",
    10751: "Aile",
    14: "Fantastik",
    36: "Tarih",
    27: "Korku",
    10402: "Müzik",
    9648: "Gizem",
    10749: "Romantik",
    878: "Bilim Kurgu",
    10770: "TV Filmi",
    53: "Gerilim",
    10752: "Savaş",
    37: "Western",
  };

  String reverseDate(String? releaseDate) {
    if (releaseDate == null || releaseDate.isEmpty) return 'Bilinmiyor';
    try {
      // Tarihi "-" karakterine göre ayır
      final parts = releaseDate.split('-');
      if (parts.length == 3) {
        // Gelen tarih sırasını ters çevir: Yıl-Ay-Gün -> Gün-Ay-Yıl
        final day = parts[2];
        final month = parts[1];
        final year = parts[0];

        // Ay numarasını Türkçe yazıya çevir
        const months = [
          'Ocak',
          'Şubat',
          'Mart',
          'Nisan',
          'Mayıs',
          'Haziran',
          'Temmuz',
          'Ağustos',
          'Eylül',
          'Ekim',
          'Kasım',
          'Aralık'
        ];
        final monthName = months[int.parse(month) - 1];

        return "$day $monthName $year"; // Ters çevrilmiş tarih
      }
      return 'Bilinmiyor';
    } catch (e) {
      return 'Bilinmiyor';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 6, 26),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 20, 13, 13),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Geri gitmek için Navigator.pop kullanılır
          },
        ),
        title: Text(
          widget.movie.title, // Filmin adını burada gösteriyoruz
          style: TextStyle(
            color: Colors.white, // Yazı rengi
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true, // Başlığı ortalamak için
        actions: [
          Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.error, size: 100, color: Colors.red),
                ),
              ),
              SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Yönetmen Bilgisi
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Yönetmen adı
                      Text(
                        director.name.isNotEmpty
                            ? director.name
                            : "Yönetmen Bilinmiyor",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      CircleAvatar(
                        radius: 30, // Fotoğraf boyutu
                        backgroundImage: director.profilePhotoUrl != null
                            ? NetworkImage(director.profilePhotoUrl!)
                            : null,
                        backgroundColor: Colors.grey,
                        child: director.profilePhotoUrl == null
                            ? Icon(Icons.person, color: Colors.white, size: 30)
                            : null,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Yayınlanış Tarihi: ${reverseDate(widget.movie.releaseDate)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      // Türler
                      Text(
                        "Tür: ${widget.movie.genreIds != null && widget.movie.genreIds!.isNotEmpty ? widget.movie.genreIds!.map((id) => genreMap[id] ?? 'Bilinmiyor').join(', ') : 'Bilinmiyor'}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Spacer(), // Yönetmen ve IMDB puanı arasındaki boşluğu oluşturur

                  // IMDB Puanı
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber, // Sarı kutu
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.white, size: 18), // Yıldız ikonu
                            SizedBox(width: 4),
                            Text(
                              widget.movie.voteAverage
                                  .toStringAsFixed(1), // Puan
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Film Konusu
              Text(
                widget.movie.overview,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              SizedBox(height: 16),

              if (watchProvidersWithIcons.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Bu platform da izleyebilirsiniz:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, // Yatay kaydırma ekledik
                        child: Row(
                          children:
                              watchProvidersWithIcons.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0), // İkonlar arasında boşluk
                              child: Image.network(
                                entry.value, // API'den gelen ikon URL
                                width: 50,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image,
                                        size: 50, color: Colors.grey),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<List<Actor>>(
                      future: ActorService.fetchTopThreeActors(
                          int.parse(widget.movie.id), 10),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Bir hata oluştu.');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('Oyuncu bilgisi bulunamadı.');
                        } else {
                          final actors = snapshot.data!;
                          return Row(
                            children: actors.map((actor) {
                              return OyuncuCircleAvatar(actor: actor);
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              SizedBox(height: 24),
              FutureBuilder<List<MoviePost>>(
                future: fetchMoviePosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Bir hata oluştu.',
                        style: TextStyle(color: Colors.white));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                      'Henüz bu film hakkında paylaşım yapılmamış.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    );
                  } else {
                    final posts = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kullanıcı Yorumları",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ...posts.map((post) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: post.user.profilePhotoUrl !=
                                            null &&
                                        post.user.profilePhotoUrl!.isNotEmpty
                                    ? NetworkImage(post.user.profilePhotoUrl!)
                                    : null,
                                backgroundColor: Colors.grey,
                                child: post.user.profilePhotoUrl == null ||
                                        post.user.profilePhotoUrl!.isEmpty
                                    ? Icon(Icons.person,
                                        color: Colors.white, size: 30)
                                    : null,
                              ),
                              title: Text(
                                post.user.userName ?? "Bilinmeyen Kullanıcı",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                post.content,
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
