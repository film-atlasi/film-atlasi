import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
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

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  /// **🔥 Firebase'den Lazy Load ile Postları Çekme**
  Future<void> _fetchPosts({bool isRefresh = false}) async {
    if (_isLoading || (!_hasMore && !isRefresh)) return;

    setState(() => _isLoading = true);

    try {
      Query query = _firestore
          .collectionGroup('posts')
          .where("source", isEqualTo: "films")
          .orderBy('timestamp', descending: true)
          .limit(_postLimit);

      if (!isRefresh && _lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.get();

      if (!mounted) return;

      if (isRefresh) {
        _moviePosts.clear();
        _lastDocument = null;
        _hasMore = true;
      }

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

    if (isRefresh) {
      _refreshController.refreshCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      header: BezierHeader(
        bezierColor: AppConstants(context).primaryColor,
        child: LoadingWidget(),
      ),
      onRefresh: () async {
        _lastDocument = null;
        _hasMore = true;
        _moviePosts.clear();
        await _fetchPosts(isRefresh: true);
      },
      child: ListView.builder(
        primary: true, // **🔥 NestedScrollView ile uyumlu hale getirildi**
        itemCount: _moviePosts.length + 1,
        itemBuilder: (context, index) {
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
          return MoviePostCard(moviePost: _moviePosts[index]);
        },
      ),
    );
  }
}
