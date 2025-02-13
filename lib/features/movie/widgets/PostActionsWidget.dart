import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostActionsWidget extends StatefulWidget {
  final String postId; // Firestore'daki postun gerçek ID'si
  final int initialLikes;
  final int initialComments;

  const PostActionsWidget({
    Key? key,
    required this.postId,
    required this.initialLikes,
    required this.initialComments,
  }) : super(key: key);

  @override
  _PostActionsWidgetState createState() => _PostActionsWidgetState();
}

class _PostActionsWidgetState extends State<PostActionsWidget> {
  int likes = 0;
  int comments = 0;
  bool isLiked = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    likes = widget.initialLikes;
    comments = widget.initialComments;
    checkIfUserLiked();
  }

  /// **Beğeni durumunu kontrol et**
  Future<void> checkIfUserLiked() async {
    final user = auth.currentUser;
    if (user == null) return;

    final postRef = firestore.collection('posts').doc(widget.postId);
    final postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      final likedUsers =
          List<String>.from(postSnapshot.get('likedUsers') ?? []);
      setState(() {
        isLiked = likedUsers.contains(user.uid);
      });
    }
  }

  Future<void> toggleLike() async {
    final user = auth.currentUser;
    if (user == null) return;

    final postRef = firestore.collection('posts').doc(widget.postId);
    final postSnapshot = await postRef.get();

    if (!postSnapshot.exists) return;

    final likedUsers = List<String>.from(postSnapshot.get('likedUsers') ?? []);

    bool isCurrentlyLiked = likedUsers.contains(user.uid);
    int newLikesCount = isCurrentlyLiked ? likes - 1 : likes + 1;

    try {
      await postRef.update({
        'likes': newLikesCount,
        'likedUsers': isCurrentlyLiked
            ? likedUsers.where((id) => id != user.uid).toList()
            : [...likedUsers, user.uid],
      });

      setState(() {
        isLiked = !isCurrentlyLiked;
        likes = newLikesCount;
      });

      print("Beğeni güncellendi! Yeni like sayısı: $likes");
    } catch (e) {
      print("Firestore beğeni güncelleme hatası: $e");
    }
  }

  /// **Yorum sayısını artırma**
  Future<void> addComment() async {
    final postRef = firestore.collection('posts').doc(widget.postId);
    await postRef.update({'comments': FieldValue.increment(1)});

    setState(() {
      comments++;
    });
  }

  /// **Paylaş butonu (Henüz Firebase ile entegre değil)**
  void sharePost() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Paylaşma özelliği yakında!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // **Beğeni Butonu**
        IconButton(
          onPressed: toggleLike,
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.white,
          ),
        ),
        Text(likes.toString(), style: TextStyle(color: Colors.white)),

        const SizedBox(width: 20),

        // **Yorum Butonu**
        IconButton(
          onPressed: addComment,
          icon: const Icon(Icons.comment_outlined, color: Colors.white),
        ),
        Text(comments.toString(), style: TextStyle(color: Colors.white)),

        const SizedBox(width: 20),

        // **Paylaş Butonu**
        IconButton(
          onPressed: sharePost,
          icon: const Icon(Icons.share, color: Colors.white),
        ),
      ],
    );
  }
}
