import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowingFeedPage extends StatefulWidget {
  const FollowingFeedPage({super.key});

  @override
  _FollowingFeedPageState createState() => _FollowingFeedPageState();
}

class _FollowingFeedPageState extends State<FollowingFeedPage> {
  final ScrollController _scrollController = ScrollController();
  final List<MoviePost> _moviePosts = [];
  Map<String, DocumentSnapshot?> _lastDocuments = {};
  bool _isLoading = false;
  bool _hasMore = true;
  final int _postLimit = 5;

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
      body: RefreshIndicator(
        onRefresh: () async {
          if (!mounted) return;
          setState(() {
            _moviePosts.clear();
            _lastDocuments.clear();
            _hasMore = true;
          });
          await _fetchFollowingPosts();
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _moviePosts.length + 1,
          itemBuilder: (context, index) {
            if (index == _moviePosts.length) {
              return _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SizedBox();
            }
            return MoviePostCard(moviePost: _moviePosts[index]);
          },
        ),
      ),
    );
  }
}
