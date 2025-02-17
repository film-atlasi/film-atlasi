import 'dart:convert';
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/screens/ActorMoviesPage.dart';
import 'package:film_atlasi/features/movie/screens/FilmDetay.dart';
import 'package:film_atlasi/features/movie/services/ActorService.dart';
import 'package:film_atlasi/features/movie/widgets/%20PostActionsWidget%20.dart';
import 'package:film_atlasi/features/movie/widgets/FilmBilgiWidget.dart';
import 'package:film_atlasi/features/movie/widgets/OyuncuCircleAvatar.dart';
import 'package:film_atlasi/features/movie/widgets/PostSilmeDuzenle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Film Post ve Kullanıcı Modeli
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore kullanıyorsan ekle

class MoviePostCard extends StatefulWidget {
  final MoviePost moviePost;
  final bool isOwnPost;

  MoviePostCard({required this.moviePost, this.isOwnPost = false});

  @override
  _MoviePostCardState createState() => _MoviePostCardState();
}

class _MoviePostCardState extends State<MoviePostCard> {
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.moviePost.content;
  }

  // 🔹 **Postu Silme Fonksiyonu**
  void _deletePost() async {
    bool confirmDelete = await _showConfirmationDialog();
    if (confirmDelete) {
      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.moviePost.postId) // Firestore'da post ID ile sil
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gönderi silindi!")),
        );

        setState(() {}); // UI'yi güncelle
      } catch (e) {
        print("Silme hatası: $e");
      }
    }
  }

  // 🔹 **Düzenleme Fonksiyonu**
  void _editPost() async {
    String? updatedContent = await _showEditDialog();
    if (updatedContent != null) {
      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.moviePost.postId)
            .update({"content": updatedContent});

        setState(() {
          widget.moviePost.content = updatedContent;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gönderi güncellendi!")),
        );
      } catch (e) {
        print("Güncelleme hatası: $e");
      }
    }
  }

  // 🔹 **Silme İçin Onay Penceresi**
  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Gönderiyi Sil"),
            content: Text("Bu gönderiyi silmek istediğinize emin misiniz?"),
            actions: [
              TextButton(
                child: Text("İptal"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text("Sil"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  // 🔹 **Düzenleme İçin Dialog Penceresi**
  Future<String?> _showEditDialog() async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Gönderiyi Düzenle"),
          content: TextField(
            controller: _contentController,
            maxLines: 4,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () => Navigator.pop(context, null),
            ),
            TextButton(
              child: Text("Kaydet"),
              onPressed: () {
                Navigator.pop(context, _contentController.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: Colors.white54, thickness: 1),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.moviePost.user.profilePhotoUrl != null
                      ? NetworkImage(widget.moviePost.user.profilePhotoUrl!)
                      : null,
                  backgroundColor: Colors.white,
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  '${widget.moviePost.user.firstName ?? ''} ${widget.moviePost.user.userName ?? ''}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (widget.isOwnPost) // 🔹 Post silme düzenleme
                  PostSilmeDuzenleme(moviePost: widget.moviePost),
              ],
            ),
            SizedBox(height: 10),
            Text(
              widget.moviePost.content,
              style: TextStyle(
                color: Color.fromARGB(255, 161, 1, 182),
              ),
            ),
            SizedBox(height: 10),
            FilmBilgiWidget(
              movie: widget.moviePost.movie,
              baseImageUrl: 'https://image.tmdb.org/t/p/w500/',
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                PostActionsWidget(
                  postId: widget.moviePost.movie.id,
                  initialLikes: widget.moviePost.likes,
                  initialComments: widget.moviePost.comments,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // Kaydet aksiyonu
                  },
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
