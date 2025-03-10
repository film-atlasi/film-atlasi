import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/widgets/LoadingWidget.dart';
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
  List<MoviePost> posts = [];
  bool isLoading = false;
  DocumentSnapshot? lastDocument;
  static const int _postLimit = 5;

  @override
  void initState() {
    super.initState();
    isCurrentUser = UserServices.currentUserUid == widget.userUid;
    _loadInitialPosts();
  }

  /// **🔥 İlk Postları Yükler**
  Future<void> _loadInitialPosts({bool isRefresh = false}) async {
    if (!mounted) return;
    setState(() => isLoading = true);

    if (isRefresh) {
      posts.clear();
      lastDocument = null;
    }

    var query = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userUid)
        .collection("posts")
        .orderBy("timestamp", descending: true)
        .limit(_postLimit);

    var snapshot = await query.get();
    List<MoviePost> newPosts = snapshot.docs.map((doc) => MoviePost.fromDocument(doc)).toList();

    setState(() {
      posts = newPosts;
      lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      isLoading = false;
    });
  }

  /// **🔥 Daha Fazla Post Yükler (Sayfalama)**
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
    List<MoviePost> newPosts = snapshot.docs.map((doc) => MoviePost.fromDocument(doc)).toList();

    setState(() {
      if (newPosts.isNotEmpty) {
        posts.addAll(newPosts);
        lastDocument = snapshot.docs.last;
      } else {
        lastDocument = null;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadInitialPosts(isRefresh: true);
      },
      child: NotificationListener<ScrollNotification>(
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
                        ? LoadingWidget()
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
      ),
    );
  }
}
