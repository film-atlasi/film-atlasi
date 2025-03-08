import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/services/PostServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KaydetServices {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final String? currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> postKaydet(
      String postId, String filmId, BuildContext context) async {
    try {
      await _firestore
          .collection("users")
          .doc(currentUserId)
          .collection("kaydedilenler")
          .doc(postId)
          .set({
        "filmId": filmId,
        "postId": postId,
        "timestamp": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kaydedildi"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata: $e"),
        ),
      );
    }
  }

  Future<void> postKaydetKaldir(String postId, BuildContext context) async {
    try {
      await _firestore
          .collection("users")
          .doc(currentUserId)
          .collection("kaydedilenler")
          .doc(postId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kaldırıldı"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata: $e"),
        ),
      );
    }
  }

  Future<bool> isPostKaydedildi(String postId) async {
    final DocumentSnapshot doc = await _firestore
        .collection("users")
        .doc(currentUserId)
        .collection("kaydedilenler")
        .doc(postId)
        .get();

    return doc.exists;
  }

  Stream<QuerySnapshot> isKaydedildi(String postId) {
    return _firestore
        .collection("users")
        .doc(currentUserId)
        .collection("kaydedilenler")
        .where("postId", isEqualTo: postId)
        .snapshots();
  }

  Future<List<MoviePost>> getKaydedilenler(
      {DocumentSnapshot? lastDoc, int limit = 10}) async {
    Query query = _firestore
        .collection("users")
        .doc(currentUserId)
        .collection("kaydedilenler")
        .orderBy("timestamp", descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final QuerySnapshot snapshot = await query.get();
    final List<MoviePost> kaydedilenler = [];

    if (snapshot.docs.isEmpty) return kaydedilenler;

    for (final DocumentSnapshot doc in snapshot.docs) {
      final DocumentSnapshot filmDoc = await _firestore
          .collection("films")
          .doc(doc["filmId"])
          .collection("posts")
          .doc(doc["postId"])
          .get();

      final movie = PostServices.getPostByUid(doc["postId"]);

      final MoviePost film = MoviePost.fromDocument(filmDoc);
      kaydedilenler.add(film);
    }

    return kaydedilenler;
  }

  Future<List<MoviePost>> getMoreKaydedilenler(
      DocumentSnapshot lastDoc, int limit) async {
    Query query = _firestore
        .collection("users")
        .doc(currentUserId)
        .collection("kaydedilenler")
        .orderBy("timestamp", descending: true)
        .startAfterDocument(lastDoc)
        .limit(limit);

    final QuerySnapshot snapshot = await query.get();
    final List<MoviePost> kaydedilenler = [];

    for (final DocumentSnapshot doc in snapshot.docs) {
      final DocumentSnapshot filmDoc = await _firestore
          .collection("films")
          .doc(doc["filmId"])
          .collection("posts")
          .doc(doc["postId"])
          .get();

      final MoviePost film = MoviePost.fromDocument(filmDoc);
      kaydedilenler.add(film);
    }

    return kaydedilenler;
  }
}
