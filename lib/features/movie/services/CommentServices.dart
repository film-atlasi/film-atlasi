import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/services/notification_service..dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String filmId;
  final String postId;
  final BuildContext context;
  final TextEditingController commentController;
  final User? user;

  CommentServices(
      {required this.filmId,
      required this.postId,
      required this.context,
      required this.commentController,
      required this.user});

  /// **Yorumları Firestore'dan çek**
  Stream<QuerySnapshot> getCommentsStream() {
    return firestore
        .collection("films")
        .doc(filmId)
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> updateComment(String commentId, String newContent) async {
    if (newContent.isEmpty) return;

    try {
      await firestore
          .collection("films")
          .doc(filmId)
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({"content": newContent});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yorum güncellendi!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  void showEditDialog(String commentId, String currentText) {
    TextEditingController editController =
        TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yorumu Düzenle"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: "Yeni yorumu yazın..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                await updateComment(commentId, editController.text.trim());
                Navigator.pop(context);
              },
              child: const Text("Kaydet"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteComment(String commentId) async {
    try {
      // Firestore referansları
      DocumentReference postRef = firestore
          .collection("films")
          .doc(filmId)
          .collection('posts')
          .doc(postId);
      DocumentReference commentRef =
          postRef.collection('comments').doc(commentId);

      // Yorumu silme işlemi
      await commentRef.delete();

      // Yorum sayısını 1 azalt
      await postRef.update({'comments': FieldValue.increment(-1)});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yorum silindi!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  Future<void> addComment() async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen önce giriş yapın!")),
      );
      return;
    }

    if (commentController.text.trim().isEmpty) return;

    final userDoc = await firestore.collection('users').doc(user!.uid).get();
    String userName =
        userDoc.exists ? userDoc['userName'] ?? "Anonim" : "Anonim";
    String profilePhotoUrl = userDoc.exists
        ? userDoc['profilePhotoUrl'] ?? ""
        : ""; // 🔥 Profil fotoğrafını ekledik

    DocumentReference commentRef = firestore
        .collection("films")
        .doc(filmId)
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc();

    await commentRef.set({
      "commentId": commentRef.id,
      "userId": user!.uid,
      "userName": userName,
      "profilePhotoUrl":
          profilePhotoUrl, // 🔥 Kullanıcının profil fotoğrafını Firestore’a kaydediyoruz
      "content": commentController.text.trim(),
      "timestamp": FieldValue.serverTimestamp(),
    });

    // **🔥 Firestore'daki "comments" alanını 1 artır**
    await firestore
        .collection("films")
        .doc(filmId)
        .collection('posts')
        .doc(postId)
        .update({
      "comments": FieldValue.increment(1),
    });

    commentController.clear();
// 🔥 Bildirim ekle
    final postOwnerId = (await firestore
            .collection("films")
            .doc(filmId)
            .collection("posts")
            .doc(postId)
            .get())
        .data()?['userId'];

    if (postOwnerId != null) {
      await NotificationService().addNotification(
          toUserId: postOwnerId,
          fromUserId: user!.uid,
          fromUsername: userDoc["userName"] ?? "Bilinmeyen Kullanıcı",
          eventType: "comment",
          filmId: filmId,
          postId: postId,
          photo: userDoc["profilePhotoUrl"]);
    }
  }
}
