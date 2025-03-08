import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:flutter/material.dart';

class FilmKutusu extends StatefulWidget {
  final String userUid;
  const FilmKutusu({super.key, required this.userUid});

  @override
  State<FilmKutusu> createState() => _FilmKutusuState();
}

class _FilmKutusuState extends State<FilmKutusu> {
  bool isCurrentUser = false;
  List<dynamic> posts = [];
  bool isLoading = false;
  DocumentSnapshot? lastDocument;
  static const int _postLimit = 5;

  @override
  void initState() {
    super.initState();
    isCurrentUser = UserServices.currentUserUid == widget.userUid;
    _loadInitialPosts();
  }

  Future<void> _loadInitialPosts() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    var query = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userUid)
        .collection("posts")
        .orderBy("timestamp", descending: true)
        .limit(_postLimit);

    var snapshot = await query.get();

    posts = snapshot.docs.map((doc) => MoviePost.fromDocument(doc)).toList();
    lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future<void> _loadMorePosts() async {
    if (isLoading || lastDocument == null) return;

    setState(() => isLoading = true);

    var query = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userUid)
        .collection("posts")
        .orderBy("timestamp", descending: true)
        .startAfterDocument(lastDocument!)
        .limit(_postLimit);

    var snapshot = await query.get();
    var newPosts = snapshot.docs.map((doc) => MoviePost.fromDocument(doc)).toList();

    if (newPosts.isNotEmpty) {
      posts.addAll(newPosts);
      lastDocument = snapshot.docs.last;
    } else {
      lastDocument = null;
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent - 300) {
          _loadMorePosts();
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == posts.length) {
                  return isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }
                return MoviePostCard(
                  moviePost: posts[index],
                );
              },
              childCount: posts.length + (isLoading ? 1 : 0),
            ),
          ),
        ],
      ),
    );
  }
}
