import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/widgets/LoadingWidget.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/movie/widgets/Skeletons/FilmSeedSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class FilmSeedPage extends StatefulWidget {
  const FilmSeedPage({super.key});

  @override
  State<FilmSeedPage> createState() => _FilmSeedPageState();
}

class _FilmSeedPageState extends State<FilmSeedPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<MoviePost> _moviePosts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  final int _postLimit = 5;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  /// **🔥 Firebase'den Lazy Load ile Postları Çekme**
  Future<void> _fetchPosts() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      Query query = _firestore
          .collectionGroup('posts')
          .where("source", isEqualTo: "films")
          .orderBy('timestamp', descending: true)
          .limit(_postLimit);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.get();

      if (!mounted) return;

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
        _moviePosts.addAll(
            querySnapshot.docs.map((doc) => MoviePost.fromFirestore(doc)));
      } else {
        _hasMore = false;
      }
    } catch (e) {
      print("Hata oluştu: $e");
    }

    if (!mounted) return;

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: RefreshController(),
        header: CustomHeader(
          builder: (context, mode) {
            return Container(
                height: 55.0,
                alignment: Alignment.center,
                child: LoadingWidget());
          },
        ),
        onRefresh: () async {
          _moviePosts.clear();
          _lastDocument = null;
          _hasMore = true;
          await _fetchPosts();
          RefreshController().refreshCompleted();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (_hasMore &&
                !_isLoading &&
                scrollNotification.metrics.pixels >=
                    scrollNotification.metrics.maxScrollExtent - 300) {
              _fetchPosts();
            }
            return false;
          },
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == _moviePosts.length) {
                      if (_isLoading) {
                        return Column(
                          children: [
                            MoviePostSkeleton(),
                            AlintiSkeleton(),
                            MoviePostSkeleton(),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MoviePostCard(moviePost: _moviePosts[index]),
                    );
                  },
                  childCount: _moviePosts.length + (_isLoading ? 1 : 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
