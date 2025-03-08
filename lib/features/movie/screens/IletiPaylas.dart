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

  @override
  void initState() {
    super.initState();
  }

  Future<void> submitForm() async {
    final auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen önce giriş yapın!')),
      );
      return;
    }

    String filmId = widget.movie.id.toString();
    if (filmId.isEmpty || filmId == "null") {
      print("⚠️ HATA: filmId boş veya geçersiz!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçersiz film kimliği!')),
      );
      return;
    }

    DocumentReference filmRef = firestore.collection("films").doc(filmId);
    DocumentReference userDoc = firestore.collection("users").doc(currentUser.uid);

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
      });
    }

    String postId = firestore.collection('posts').doc().id;
    if (postId.isEmpty || postId == "null") {
      print("⚠️ HATA: postId boş veya geçersiz!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gönderi oluşturulamadı!')),
      );
      return;
    }

    Map<String, dynamic> postData = {
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
    };

    await filmRef.collection("posts").doc(postId).set(postData);
    await userDoc.collection("posts").doc(postId).set(postData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('İnceleme paylaşıldı!')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilmBilgiWidget(movieId: widget.movie.id),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _isSpoiler,
                  onChanged: (value) {
                    setState(() {
                      _isSpoiler = value!;
                    });
                  },
                ),
                const Text("Spoiler içeriyor mu?", style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            AutoSizeTextField(
              controller: _textEditingController,
              minFontSize: 16,
              maxLines: 10,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: "Filmi nasıl buldunuz?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () async {
                  if (_rating > 0 && _textEditingController.text.isNotEmpty) {
                    await submitForm();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
                    );
                  }
                },
                child: const Text('Paylaş'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
