import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/services/ActorService.dart';
import 'package:film_atlasi/features/movie/widgets/FilmListButton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:auto_size_text/auto_size_text.dart'; // AutoSizeText kütüphanesini eklemeyi unutmayın!

class Iletipaylas extends StatefulWidget {
  final Movie movie;
  const Iletipaylas({super.key, required this.movie});

  @override
  State<Iletipaylas> createState() => _IletipaylasState();
}

class _IletipaylasState extends State<Iletipaylas> {
  double _rating = 0.0;
  final TextEditingController _textEditingController = TextEditingController();

  bool? _recommendation;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> submitForm() async {
    try {
      final film = widget.movie;
      String film_id = film.id.toString();
      DocumentReference filmRef = firestore.collection("films").doc(film_id);
      final auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;

      DocumentSnapshot filmSnapshot = await filmRef.get();

      if (!filmSnapshot.exists) {
        //eğer film yoksa
        final filmData = film;
        await filmRef.set({
          'id': film_id,
          "title": filmData.title,
          "posterPath": filmData.posterPath,
          "overview": filmData.overview,
          "voteAverage": filmData.voteAverage,
          "genre_ids": filmData.genreIds,
          "release_date": filmData.releaseDate,
          "vote_average": filmData.voteAverage
        });
      }

      await firestore.collection("posts").add({
        "user": currentUser!.uid,
        "movie": film_id,
        "likes": 0,
        "comments": 0,
        "content": _textEditingController.text,
        "timestamp": FieldValue.serverTimestamp(), // Server zamanı
      });
    } catch (e) {
      print("Hata oluştu: $e"); // Hata detayını konsola yazdırır
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildDetaylar(context),
        ),
      ),
    );
  }

  List<Widget> buildDetaylar(BuildContext context) {
    final TextTheme _textTheme = Theme.of(context).textTheme;

    return [
      if (widget.movie.posterPath.isNotEmpty)
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.error, size: 100, color: Colors.red),
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              widget.movie.title,
              style: _textTheme.titleLarge,
            ),
            AddVerticalSpace(context, 0.015),
            Text(
              '5 üzerinden kaç verdiniz?',
              style: _textTheme.bodyMedium,
            ),
            AddVerticalSpace(context, 0.005),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 10),
            AddVerticalSpace(context, 0.01),
            const Divider(color: Color.fromARGB(255, 102, 102, 102)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<List<Actor>>(
                  future: ActorService.fetchTopThreeActors(
                      int.parse(widget.movie.id), 3),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Bir hata oluştu.');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('Oyuncu bilgisi bulunamadı.');
                    } else {
                      final actors = snapshot.data!;
                      return Row(
                        children: actors.map((actor) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: actor.profilePhotoUrl != null
                                      ? NetworkImage(actor.profilePhotoUrl!)
                                      : null,
                                  backgroundColor: Colors.grey,
                                  radius: 30,
                                  child: actor.profilePhotoUrl == null
                                      ? Icon(Icons.person, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  actor.name,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
            AddVerticalSpace(context, 0.01),
            Text(
              'Film hakkındaki düşünceleriniz:',
              style: _textTheme.bodyMedium,
            ),
            AddVerticalSpace(context, 0.01),
            AutoSizeTextField(
              controller: _textEditingController,
              minFontSize: 20,
              maxLines: 7,
              style: const TextStyle(fontSize: 30),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(20)),
            ),
            AddVerticalSpace(context, 0.03),
            const SizedBox(height: 10),
            AddToMyListButton(),
            const SizedBox(height: 20),
            buildPaylasButton(context),
          ],
        ),
      ),
    ];
  }

  Center buildPaylasButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_rating > 0 && _textEditingController.text.isNotEmpty) {
            await submitForm();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('İnceleme paylaşıldı!')),
            );
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/anasayfa', (route) => false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: const Text('Paylaş'),
      ),
    );
  }
}
