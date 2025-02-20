import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  final String postId;

  const CommentPage({Key? key, required this.postId}) : super(key: key);

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
    TextEditingController _editController =
        TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yorumu Düzenle"),
          content: TextField(
            controller: _editController,
            decoration: const InputDecoration(hintText: "Yeni yorumu yazın..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                await _updateComment(commentId, _editController.text.trim());
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
      DocumentReference postRef =
          firestore.collection('posts').doc(widget.postId);
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
    await firestore.collection('posts').doc(widget.postId).update({
      "comments": FieldValue.increment(1),
    });

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yorumlar")),
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

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: commentData['profilePhotoUrl'] !=
                                    null &&
                                commentData['profilePhotoUrl'].isNotEmpty
                            ? NetworkImage(commentData[
                                'profilePhotoUrl']) // 🔥 Profil fotoğrafını gösteriyoruz
                            : null,
                        child: commentData['profilePhotoUrl'] == null ||
                                commentData['profilePhotoUrl'].isEmpty
                            ? Text(commentData['userName'][0]
                                .toUpperCase()) // Eğer profil fotoğrafı yoksa baş harfi göster
                            : null,
                      ),
                      title: Text(
                        commentData['userName'] ?? 'Anonim',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(commentData['content']),
                      trailing: commentData['userId'] == auth.currentUser?.uid
                          ? PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showEditDialog(commentData['commentId'],
                                      commentData['content']);
                                } else if (value == 'delete') {
                                  _deleteComment(commentData['commentId']);
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
                          : null, // Eğer yorum kullanıcının değilse, düzenleme/silme butonu göstermiyoruz.
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
