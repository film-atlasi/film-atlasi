import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/widgets/FilmBilgiWidget.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:palette_generator/palette_generator.dart';

class Iletipaylas extends StatefulWidget {
  final Movie movie;
  final bool isFromQuote;

  const Iletipaylas({super.key, required this.movie, this.isFromQuote = false});

  @override
  State<Iletipaylas> createState() => _IletipaylasState();
}

class _IletipaylasState extends State<Iletipaylas> {
  double _rating = 0.0;
  bool _isSpoiler = false;
  final TextEditingController _textEditingController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Color mutedColorDark = Colors.black;
  Color mutedColorLight = Colors.grey;
  final String baseImageUrl = "https://image.tmdb.org/t/p/w500/";
  bool colorGenerated = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDominantColor();
  }

  Future<void> _fetchDominantColor() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage("$baseImageUrl${widget.movie.posterPath}"),
    );
    setState(() {
      mutedColorDark = paletteGenerator.darkMutedColor?.color ?? Colors.black;
      mutedColorLight = paletteGenerator.lightMutedColor?.color ?? Colors.grey;
      colorGenerated = true;
    });
  }

  Future<void> submitForm() async {
    final auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
    setState(() {
      isLoading = true;
    });

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen önce giriş yapın!')),
      );
      return;
    }

    String filmId = widget.movie.id.toString();
    if (filmId.isEmpty || filmId == "null") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçersiz film kimliği!')),
      );
      return;
    }

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
        "title": widget.movie.title,
        "posterPath": widget.movie.posterPath,
        "overview": widget.movie.overview,
        "voteAverage": widget.movie.voteAverage,
        "genre_ids": widget.movie.genreIds,
        "release_date": widget.movie.releaseDate,
        "dominantColorDark": Helpers.colorToInt(mutedColorDark),
        "dominantColorLight": Helpers.colorToInt(mutedColorLight),
      });
    }

    String postId = firestore.collection('posts').doc().id;

    Map<String, dynamic> postDataForMovie = {
      "postId": postId,
      "userId": user.uid,
      "filmName": widget.movie.title,
      "filmId": filmId,
      "filmIcerik": widget.movie.overview,
      "firstName": user.firstName,
      "username": user.userName,
      "userPhotoUrl": user.profilePhotoUrl,
      "content": _textEditingController.text,
      "isQuote": widget.isFromQuote,
      "likes": 0,
      "comments": 0,
      "rating": _rating,
      "timestamp": FieldValue.serverTimestamp(),
      "isSpoiler": _isSpoiler,
      "source": "films"
    };

    Map<String, dynamic> postDataForUser = {
      "postId": postId,
      "userId": user.uid,
      "filmName": widget.movie.title,
      "filmId": filmId,
      "filmIcerik": widget.movie.overview,
      "firstName": user.firstName,
      "username": user.userName,
      "userPhotoUrl": user.profilePhotoUrl,
      "content": _textEditingController.text,
      "isQuote": widget.isFromQuote,
      "likes": 0,
      "comments": 0,
      "rating": _rating,
      "timestamp": FieldValue.serverTimestamp(),
      "isSpoiler": _isSpoiler,
      "source": "users"
    };

    await filmRef.collection("posts").doc(postId).set(postDataForMovie);
    await userDoc.collection("posts").doc(postId).set(postDataForUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('İnceleme paylaşıldı!')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          "İleti Paylaş",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilmBilgiWidget(movieId: widget.movie.id),
            const SizedBox(height: 15),
            SwitchListTile(
              title: const Text(
                "Spoiler içeriyor mu?",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              value: _isSpoiler,
              activeColor: Colors.red,
              onChanged: (value) {
                setState(() {
                  _isSpoiler = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
            ),
            const SizedBox(
                height:
                    30), // Yıldız ile görüş alanı arasına daha fazla boşluk eklendi
            TextField(
              controller: _textEditingController,
              maxLines: 6,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                hintText: "Filmi nasıl buldunuz?",
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: GestureDetector(
                onTap: isLoading && colorGenerated
                    ? null
                    : () async {
                        if (_rating > 0 &&
                            _textEditingController.text.isNotEmpty) {
                          await submitForm();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Lütfen tüm alanları doldurun!')),
                          );
                        }
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.red],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: isLoading && colorGenerated
                      ? CircleAvatar(
                          radius: 4,
                          foregroundColor: Colors.white,
                        )
                      : const Text(
                          "Paylaş",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
