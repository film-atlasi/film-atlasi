import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/services/notification_service..dart';
import 'package:film_atlasi/features/user/widgets/UserProfileRouter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class CommentPage extends StatefulWidget {
  final String postId;
  final String filmId;
  final bool isAppBar;
  const CommentPage(
      {super.key,
      required this.postId,
      required this.filmId,
      this.isAppBar = true});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// **Yorumları Firestore'dan çek**
  Stream<QuerySnapshot> getCommentsStream() {
    return firestore
        .collection("films")
        .doc(widget.filmId)
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _updateComment(String commentId, String newContent) async {
    if (newContent.isEmpty) return;

    try {
      await firestore
          .collection("films")
          .doc(widget.filmId)
          .collection('posts')
          .doc(widget.postId)
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

  void _showEditDialog(String commentId, String currentText) {
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
                await _updateComment(commentId, editController.text.trim());
                Navigator.pop(context);
              },
              child: const Text("Kaydet"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      // Firestore referansları
      DocumentReference postRef = firestore
          .collection("films")
          .doc(widget.filmId)
          .collection('posts')
          .doc(widget.postId);
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
    final user = auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen önce giriş yapın!")),
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) return;

    final userDoc = await firestore.collection('users').doc(user.uid).get();
    String userName =
        userDoc.exists ? userDoc['userName'] ?? "Anonim" : "Anonim";
    String profilePhotoUrl = userDoc.exists
        ? userDoc['profilePhotoUrl'] ?? ""
        : ""; // 🔥 Profil fotoğrafını ekledik

    DocumentReference commentRef = firestore
        .collection("films")
        .doc(widget.filmId)
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc();

    await commentRef.set({
      "commentId": commentRef.id,
      "userId": user.uid,
      "userName": userName,
      "profilePhotoUrl":
          profilePhotoUrl, // 🔥 Kullanıcının profil fotoğrafını Firestore’a kaydediyoruz
      "content": _commentController.text.trim(),
      "timestamp": FieldValue.serverTimestamp(),
    });

    // **🔥 Firestore'daki "comments" alanını 1 artır**
    await firestore
        .collection("films")
        .doc(widget.filmId)
        .collection('posts')
        .doc(widget.postId)
        .update({
      "comments": FieldValue.increment(1),
    });

    _commentController.clear();
// 🔥 Bildirim ekle
    final postOwnerId = (await firestore
            .collection("films")
            .doc(widget.filmId)
            .collection("posts")
            .doc(widget.postId)
            .get())
        .data()?['userId'];

    if (postOwnerId != null) {
      await NotificationService().addNotification(
          toUserId: postOwnerId,
          fromUserId: user.uid,
          fromUsername: userDoc["userName"] ?? "Bilinmeyen Kullanıcı",
          eventType: "comment",
          filmId: widget.filmId,
          postId: widget.postId,
          photo: userDoc["profilePhotoUrl"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppBar ? AppBar(title: const Text("Yorumlar")) : null,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getCommentsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var comments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    var commentData =
                        comments[index].data() as Map<String, dynamic>;
                    var timestamp = commentData["timestamp"] as Timestamp?;
                    var formattedTime = timestamp != null
                        ? Helpers.formatTimestamp(timestamp)
                        : "Zaman bilgisi yok";

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UserProfileRouter(
                        extraWidget: Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Text(
                            formattedTime,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        userId: commentData["userId"],
                        title: commentData["userName"],
                        profilePhotoUrl: commentData["profilePhotoUrl"],
                        subtitle: commentData["content"],
                        trailing: commentData["userId"] == auth.currentUser?.uid
                            ? PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditDialog(commentData["commentId"],
                                        commentData["content"]);
                                  } else if (value == 'delete') {
                                    _deleteComment(commentData["commentId"]);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Düzenle'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Sil'),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Yorumunuzu yazın...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
