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
  final ScrollController _scrollController = ScrollController();
  List<MoviePost> _begenilenler = [];
  DocumentSnapshot? _lastDoc;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchBegeniListesi();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchBegeniListesi() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    try {
      Query query = _firestore
          .collection("users")
          .doc(widget.userUid)
          .collection("begenilenler")
          .orderBy("timestamp", descending: true)
          .limit(10);

      if (_lastDoc != null) {
        query = query.startAfterDocument(_lastDoc!);
      }

      QuerySnapshot querySnapshot = await query.get();

      List<MoviePost> yeniBegenilenler = [];

      for (var doc in querySnapshot.docs) {
        String postId = doc['postId'];
        String filmId = doc['filmId'];

        // 🎯 Film içindeki ilgili postu çekiyoruz
        DocumentSnapshot postSnapshot = await _firestore
            .collection("films")
            .doc(filmId)
            .collection("posts")
            .doc(postId)
            .get();

        if (postSnapshot.exists) {
          var data = postSnapshot.data() as Map<String, dynamic>;
          yeniBegenilenler.add(MoviePost(
            postId: postId,
            userId: data["userId"],
            firstName: data["firstName"],
            userPhotoUrl: data["userPhotoUrl"],
            username: data["username"],
            filmId: filmId,
            filmName: data["filmName"] ?? "Film Adı Yok",
            filmIcerik: data["filmIcerik"] ?? "",
            content: data["content"],
            likes: data["likes"] ?? 0,
            comments: data["comments"] ?? 0,
            isQuote: data["isQuote"] ?? false,
            rating: (data["rating"] ?? 0).toDouble(),
            timestamp: data["timestamp"] as Timestamp,
            isSpoiler: data["isSpoiler"] ?? false,
          ));
        }
      }

      setState(() {
        _begenilenler.addAll(yeniBegenilenler);
        _lastDoc =
            querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
        _isLoading = false;
        _hasMore = yeniBegenilenler.length == 5;
      });
    } catch (e) {
      print("🔥 Hata: Beğenilen postlar çekilemedi: $e");
      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchBegeniListesi();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _begenilenler.isEmpty && _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: _scrollController,
            itemCount: _begenilenler.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _begenilenler.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return MoviePostCard(moviePost: _begenilenler[index]);
            },
          );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
