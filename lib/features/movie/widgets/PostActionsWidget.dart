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
    final likesRef = postRef.collection('likes').doc(user.uid);

    final likeSnapshot = await likesRef.get();

    if (likeSnapshot.exists) {
      // Eğer kullanıcı zaten beğenmişse, beğeniyi kaldır
      await likesRef.delete();
      await postRef
          .set({'likes': FieldValue.increment(-1)}, SetOptions(merge: true));
      setState(() {
        isLiked = false;
        likes--;
      });
    } else {
      // Eğer beğenmemişse, beğeni ekle
      await likesRef
          .set({'userId': user.uid, 'timestamp': FieldValue.serverTimestamp()});
      await postRef
          .set({'likes': FieldValue.increment(1)}, SetOptions(merge: true));
      setState(() {
        isLiked = true;
        likes++;
      });
    }
  }

  void _showLikers() async {
    var likesRef =
        firestore.collection('posts').doc(widget.postId).collection('likes');
    var snapshot = await likesRef.get();

    List<String> likers = snapshot.docs.map((doc) => doc.id).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Beğenenler"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: likers
                .map((userId) => FutureBuilder<DocumentSnapshot>(
                      future: firestore.collection('users').doc(userId).get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData)
                          return CircularProgressIndicator();
                        String userName =
                            userSnapshot.data!.get('userName') ?? 'Bilinmiyor';
                        return ListTile(title: Text(userName));
                      },
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Kapat"),
            )
          ],
        );
      },
    );
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
        StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection('posts').doc(widget.postId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text("0", style: TextStyle(color: Colors.white));
            }

            int likeCount = snapshot.data!.get('likes') ?? 0;
            return GestureDetector(
              onTap: _showLikers,
              child: Text(likeCount.toString(),
                  style: TextStyle(color: Colors.white)),
            );
          },
        ),
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