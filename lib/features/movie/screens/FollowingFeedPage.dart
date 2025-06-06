import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/widgets/LoadingWidget.dart';
import 'package:film_atlasi/features/movie/widgets/Skeletons/FilmSeedSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class FollowingFeedPage extends StatefulWidget {
  const FollowingFeedPage({super.key});

  @override
  _FollowingFeedPageState createState() => _FollowingFeedPageState();
}

class _FollowingFeedPageState extends State<FollowingFeedPage> {
  final ScrollController _scrollController = ScrollController();
  final List<MoviePost> _moviePosts = [];
  Map<String, DocumentSnapshot?> _lastDocuments = {};
  RefreshController _refreshController = RefreshController();
  bool _isLoading = false;
  bool _hasMore = true;
  final int _postLimit = 4;

  @override
  void initState() {
    super.initState();
    _fetchFollowingPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
        .removeListener(_onScroll); // ✅ Hata önlemek için listener kaldır
    _scrollController.dispose();
    super.dispose();
  }

  /// **🔥 Firebase'den Lazy Load ile Takip Edilen Kullanıcıların Postlarını Çek**
  Future<void> _fetchFollowingPosts() async {
    if (!mounted || _isLoading || !_hasMore) {
      return; // ✅ Widget hala var mı kontrol et
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
        return;
      }

      var response = await UserServices.getFollowingUsersPostsLazy(
        userUid: user.uid,
        lastDocuments: _lastDocuments,
        limit: _postLimit,
      );

      List<MoviePost> newPosts = response["posts"];
      Map<String, DocumentSnapshot?> newLastDocuments =
          response["lastDocuments"];

      if (!mounted) return; // ✅ Widget kaldırılmışsa setState() çağırma

      setState(() {
        if (newPosts.isNotEmpty) {
          _lastDocuments = newLastDocuments;
          _moviePosts.addAll(newPosts);
        } else {
          _hasMore = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      print("Hata oluştu: $e");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// **🔥 Aşağı kaydırma kontrolü**
  void _onScroll() {
    if (_isLoading || !_hasMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _fetchFollowingPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () async {
          _lastDocuments = {};
          _moviePosts.clear();
          _hasMore = true;
          await _fetchFollowingPosts();
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          await _fetchFollowingPosts();
        },
        footer: ClassicFooter(
          loadingText: _hasMore ? "Yükleniyor..." : " . ",
          loadingIcon: _hasMore ? LoadingWidget() : null,
          idleText: _hasMore
              ? "Daha fazla gönderi yüklemek için aşağı çekin"
              : "daha fazla gönderi yok",
          noDataText: "Daha fazla gönderi yok",
          textStyle: TextStyle(color: AppConstants(context).textColor),
        ),
        header: BezierHeader(
          bezierColor: AppConstants(context).primaryColor,
          child: LoadingWidget(url: "assets/animations/loading.json"),
        ),
        child: ListView.builder(
          primary: true,
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
      ),
    );
  }
}
