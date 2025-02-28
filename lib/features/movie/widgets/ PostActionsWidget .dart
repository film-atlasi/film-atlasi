import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/services/notification_service..dart';
import 'package:film_atlasi/features/movie/widgets/CommentPage.dart';
import 'package:film_atlasi/features/user/widgets/UserProfileRouter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostActionsWidget extends StatefulWidget {
  final String postId;
  final String filmId;
  final int initialLikes;
  final int initialComments;

  const PostActionsWidget(
      {super.key,
      required this.postId,
      required this.initialLikes,
      required this.initialComments,
      required this.filmId});

  @override
  _PostActionsWidgetState createState() => _PostActionsWidgetState();
}

class _PostActionsWidgetState extends State<PostActionsWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<DocumentSnapshot> _postStream;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    // _postStream değişkenini başlat
    _postStream = _firestore
        .collection("films")
        .doc(widget.filmId)
        .collection('posts')
        .doc(widget.postId)
        .snapshots();
    _checkIfUserLiked();
  }

  Future<void> _checkIfUserLiked() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final likesSnapshot = await _firestore
          .collection("films")
          .doc(widget.filmId)
          .collection('posts')
          .doc(widget.postId)
          .collection('likes')
          .doc(user.uid)
          .get();

      if (mounted) {
        setState(() {
          _isLiked = likesSnapshot.exists;
        });
      }
    } catch (e) {
      print('Beğeni durumu kontrol edilirken hata: $e');
    }
  }

  Future<void> _toggleLike() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Batch işlemi oluştur
    final batch = _firestore.batch();
    final filmRef = _firestore.collection('films').doc(widget.filmId);
    final postRef = filmRef.collection('posts').doc(widget.postId);
    final likeRef = postRef.collection('likes').doc(user.uid);
    final userRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await userRef.get();

    try {
      // Önce mevcut durumu kontrol et
      final likeDoc = await likeRef.get();

      if (likeDoc.exists) {
        // Beğeniyi kaldır
        batch.delete(likeRef);
        batch.update(postRef, {'likes': FieldValue.increment(-1)});

        if (mounted) {
          setState(() {
            _isLiked = false;
          });
        }
      } else {
        // Beğeni ekle
        batch.set(likeRef, {
          'userId': user.uid,
          'userName': userDoc["userName"] ?? 'Kullanıcı',
          'timestamp': FieldValue.serverTimestamp(),
          'profilePhotoUrl': userDoc["profilePhotoUrl"]
        });
        batch.update(postRef, {'likes': FieldValue.increment(1)});

//bildirim ekle begeni
        final postOwner = await postRef.get();
        final postOwnerId =
            postOwner.data()?['userId']; // Post sahibinin UID’si
        if (postOwnerId != null) {
          await NotificationService().addNotification(
              toUserId: postOwnerId,
              fromUserId: user.uid,
              fromUsername: userDoc["userName"] ?? "Bilinmeyen Kullanıcı",
              eventType: "like",
              filmId: widget.filmId,
              photo: userDoc["profilePhotoUrl"]);
        }

        if (mounted) {
          setState(() {
            _isLiked = true;
          });
        }
      }

      // Batch işlemini commit et
      await batch.commit();
    } catch (e) {
      print('Beğeni işlemi sırasında hata: $e');
    }
  }

  void _navigateToComments() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentPage(
          postId: widget.postId,
          filmId: widget.filmId,
        ),
      ),
    );

    // CommentPage'den döndükten sonra, eğer yeni yorum eklendiyse
    // yorum sayısı otomatik olarak StreamBuilder ile güncellenecek
  }

  void _showLikers() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Beğenenler'),
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("films")
                  .doc(widget.filmId)
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('likes')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Henüz beğeni yok'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var likeData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return UserProfileRouter(
                        userId: likeData['userId'],
                        title: likeData["userName"],
                        profilePhotoUrl: likeData["profilePhotoUrl"]);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  void _sharePost() {
    // Paylaşma mantığı burada
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paylaşma özelliği yakında!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _postStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Row(
            children: [
              IconButton(
                onPressed: null,
                icon: Icon(Icons.favorite_border, color: Colors.grey),
              ),
              Text('0', style: TextStyle(color: Colors.white)),
              SizedBox(width: 20),
              IconButton(
                onPressed: null,
                icon: Icon(Icons.comment_outlined, color: Colors.grey),
              ),
              Text('0', style: TextStyle(color: Colors.white)),
              SizedBox(width: 20),
              IconButton(
                onPressed: null,
                icon: Icon(Icons.share, color: Colors.grey),
              ),
            ],
          );
        }

        final postData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        final int likeCount = postData['likes'] ?? 0;
        final int commentCount = postData['comments'] ?? 0;

        return Row(
          children: [
            // Beğeni Butonu
            IconButton(
              onPressed: _toggleLike,
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : Colors.white,
              ),
            ),
            GestureDetector(
              onTap: likeCount > 0 ? _showLikers : null,
              child: Text(
                '$likeCount',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 20),

            // Yorum Butonu
            IconButton(
              onPressed: _navigateToComments,
              icon: Icon(Icons.comment_outlined, color: Colors.white),
            ),
            Text(
              '$commentCount',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 20),

            // Paylaş Butonu
            IconButton(
              onPressed: _sharePost,
              icon: Icon(Icons.share, color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}
