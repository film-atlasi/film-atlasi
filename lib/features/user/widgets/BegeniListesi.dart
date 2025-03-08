import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:flutter/material.dart';

class BegeniListesi extends StatefulWidget {
  final String userUid;
  const BegeniListesi({super.key, required this.userUid});

  @override
  State<BegeniListesi> createState() => _BegeniListesiState();
}

class _BegeniListesiState extends State<BegeniListesi> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<MoviePost> _begenilenler = [];
  bool isLoading = false;
  DocumentSnapshot? lastDocument;
  static const int _postLimit = 5;

  @override
  void initState() {
    super.initState();
    _loadInitialLikedPosts();
  }

  Future<void> _loadInitialLikedPosts() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    var query = _firestore
        .collection("users")
        .doc(widget.userUid)
        .collection("begenilenler")
        .orderBy("timestamp", descending: true)
        .limit(_postLimit);

    var snapshot = await query.get();

    List<MoviePost> yeniBegenilenler = await _fetchLikedPosts(snapshot);

    _begenilenler.addAll(yeniBegenilenler);
    lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future<void> _loadMoreLikedPosts() async {
    if (isLoading || lastDocument == null) return;

    setState(() => isLoading = true);

    var query = _firestore
        .collection("users")
        .doc(widget.userUid)
        .collection("begenilenler")
        .orderBy("timestamp", descending: true)
        .startAfterDocument(lastDocument!)
        .limit(_postLimit);

    var snapshot = await query.get();
    List<MoviePost> yeniBegenilenler = await _fetchLikedPosts(snapshot);

    if (yeniBegenilenler.isNotEmpty) {
      _begenilenler.addAll(yeniBegenilenler);
      lastDocument = snapshot.docs.last;
    } else {
      lastDocument = null;
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  // **📌 Beğenilen postları getir**
  Future<List<MoviePost>> _fetchLikedPosts(QuerySnapshot snapshot) async {
    List<MoviePost> yeniBegenilenler = [];

    for (var doc in snapshot.docs) {
      String postId = doc['postId'];
      String filmId = doc['filmId'];

      // 🎯 Firestore'dan beğenilen postu getir
      DocumentSnapshot postSnapshot = await _firestore
          .collection("films")
          .doc(filmId)
          .collection("posts")
          .doc(postId)
          .get();

      if (postSnapshot.exists) {
        yeniBegenilenler.add(MoviePost.fromDocument(postSnapshot));
      }
    }
    return yeniBegenilenler;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels >=
            scrollNotification.metrics.maxScrollExtent - 300) {
          _loadMoreLikedPosts();
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == _begenilenler.length) {
                  return isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }
                return MoviePostCard(
                  moviePost: _begenilenler[index],
                );
              },
              childCount: _begenilenler.length + (isLoading ? 1 : 0),
            ),
          ),
        ],
      ),
    );
  }
}
