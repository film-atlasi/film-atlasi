import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/widgets/AddToListButton.dart';
import 'package:film_atlasi/features/movie/widgets/FilmBilgiWidget.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Iletipaylas extends StatefulWidget {
  final Movie movie;
  final bool isFromQuote; // 💡 Alıntı mı, normal paylaşım mı?

  const Iletipaylas({
    super.key,
    required this.movie,
    this.isFromQuote = false, // 💡 Varsayılan olarak normal paylaşım
  });

  @override
  State<Iletipaylas> createState() => _IletipaylasState();
}

const String baseImageUrl = 'https://image.tmdb.org/t/p/w500';

class _IletipaylasState extends State<Iletipaylas> {
  double _rating = 0.0;
  final TextEditingController _textEditingController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> submitForm() async {
    try {
      final film = widget.movie;
      final auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen önce giriş yapın!')),
        );
        return;
      }

      String filmId = film.id.toString();
      DocumentReference filmRef = firestore.collection("films").doc(filmId);

      DocumentReference userDoc =
          firestore.collection("users").doc(currentUser.uid);
      DocumentSnapshot userSnapshot = await userDoc.get();
      if (!userSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı bilgileri bulunamadı!')),
        );
        return;
      }

      User user = User.fromFirestore(userSnapshot);

      DocumentSnapshot filmSnapshot = await filmRef.get();

      if (!filmSnapshot.exists) {
        await filmRef.set({
          'id': filmId,
          "title": film.title,
          "posterPath": film.posterPath,
          "overview": film.overview,
          "voteAverage": film.voteAverage,
          "genre_ids": film.genreIds,
          "release_date": film.releaseDate,
          "vote_average": film.voteAverage,
        });
      }

      // **Yeni Post için Firestore'da benzersiz bir ID oluştur**
      firestore.collection("posts").doc();

      // **Postu Firestore'a ekle**
      Map<String, dynamic> postData = {
        "userId": user.uid,
        "filmName": widget.movie.title,
        "filmId": widget.movie.id,
        "filmIcerik": widget.movie.overview,
        "firstName": user.firstName,
        "username": user.userName,
        "userPhotoUrl": user.profilePhotoUrl,
        "content": _textEditingController.text, // Kullanıcının yorumu
        "isQuote": widget
            .isFromQuote, // 🔥 Alıntı paylaşımı olup olmadığını işaretliyoruz
        "likes": 0,
        "comments": 0,
        "rating": _rating, // 🔥 Burada puanı kaydediyoruz!
        "likedUsers": [],
        "timestamp": FieldValue.serverTimestamp(),
      };
      Map<String, dynamic> postDataForUserCollection = {
        "userId": user.uid,
        "filmName": widget.movie.title,
        "filmId": widget.movie.id,
        "filmIcerik": widget.movie.overview,
        "firstName": user.firstName,
        "username": user.userName,
        "userPhotoUrl": user.profilePhotoUrl,
        "content": _textEditingController.text, // Kullanıcının yorumu
        "isQuote": widget
            .isFromQuote, // 🔥 Alıntı paylaşımı olup olmadığını işaretliyoruz
        "likes": 0,
        "comments": 0,
        "rating": _rating, // 🔥 Burada puanı kaydediyoruz!
        "likedUsers": [],
        "timestamp": FieldValue.serverTimestamp(),
      };

      await filmRef.collection("posts").add(postData);

      await userDoc.collection("posts").add(postDataForUserCollection);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İnceleme paylaşıldı!')),
      );

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/anasayfa', (route) => false);
    } catch (e) {
      print("Hata oluştu: $e");
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
    final TextTheme textTheme = Theme.of(context).textTheme;

    return [
      if (widget.movie.posterPath.isNotEmpty)
        Stack(
          children: [
            SizedBox(
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
              style: textTheme.titleLarge,
            ),
            AddVerticalSpace(context, 0.015),
            Text(
              '5 üzerinden kaç verdiniz?',
              style: textTheme.bodyMedium,
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
            FilmBilgiWidget(
              movieId: widget.movie.id,
              baseImageUrl: 'https://image.tmdb.org/t/p/w500/',
            ),
            AddVerticalSpace(context, 0.01),
            Text(
              'Film hakkındaki düşünceleriniz:',
              style: textTheme.bodyMedium,
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
            AddToListButton(movie: widget.movie),
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
