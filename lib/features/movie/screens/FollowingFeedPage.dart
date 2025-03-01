import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowingFeedPage extends StatefulWidget {
  @override
  _FollowingFeedPageState createState() => _FollowingFeedPageState();
}

class _FollowingFeedPageState extends State<FollowingFeedPage> {
  final ScrollController _scrollController = ScrollController();
  List<MoviePost> _moviePosts = [];
  Map<String, DocumentSnapshot?> _lastDocuments =
      {}; // 🔥 Kullanıcı bazlı pagination
  bool _isLoading = false;
  bool _hasMore = true;
  final int _postLimit = 5; // Her seferde çekilecek post sayısı

  @override
  void initState() {
    super.initState();
    _fetchFollowingPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// **🔥 Firebase'den Lazy Load ile Takip Edilen Kullanıcıların Postlarını Çek**
  Future<void> _fetchFollowingPosts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
        return;
      }

      var response = await UserServices.getFollowingUsersPostsLazy(
        userUid: user.uid,
        lastDocuments: _lastDocuments, // 🔥 Kullanıcı bazlı pagination
        limit: _postLimit,
      );

      List<MoviePost> newPosts = response["posts"];
      Map<String, DocumentSnapshot?> newLastDocuments =
          response["lastDocuments"];

      if (!mounted) return;

      setState(() {
        if (newPosts.isNotEmpty) {
          _lastDocuments =
              newLastDocuments; // ✅ Kullanıcı bazlı pagination devam ediyor
          _moviePosts.addAll(newPosts);
        } else {
          _hasMore = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      print("Hata oluştu: $e");
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
          _moviePosts.clear();
          _lastDocuments.clear(); // 🔥 Kullanıcı bazlı pagination sıfırla
          _hasMore = true;
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
