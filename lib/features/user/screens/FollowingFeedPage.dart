import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/movie/widgets/BottomNavigatorBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowingFeedPage extends StatefulWidget {
  const FollowingFeedPage({super.key});

  @override
  State<FollowingFeedPage> createState() => _FollowingFeedPageState();
}

class _FollowingFeedPageState extends State<FollowingFeedPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<MoviePost> _moviePosts = []; // Post listesi
  bool _isLoading = false; // Yükleme durumu
  bool _hasMore = true; // Daha fazla veri var mı?
  DocumentSnapshot? _lastDocument; // Son çekilen belge referansı
  final int _postLimit = 5; // Her yüklemede kaç post çekilecek
  final ScrollController _scrollController = ScrollController();

  // Stream aboneliğini takip etmek için
  StreamSubscription? _followingStreamSubscription;

  // Widget ağaçtan kaldırıldı mı takip et
  bool _mounted = true;

  // Takip edilen kullanıcılar
  List<String> _followingUsers = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchFollowingUsers();
    _scrollController.addListener(_onScroll); // Kaydırmayı dinle
  }

  @override
  void dispose() {
    // Stream aboneliklerini iptal et
    _followingStreamSubscription?.cancel();

    // Scroll controller'ı temizle
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    // Widget'ın mounted durumunu güncelle
    _mounted = false;

    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  /// Takip edilen kullanıcıların ID'lerini getir
  Future<void> _fetchFollowingUsers() async {
    if (!_mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Takip edilen kullanıcıları dinle
      _followingStreamSubscription = _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('following')
          .snapshots()
          .listen((snapshot) {
        // Stream callback - widget mounted mu kontrol et
        if (!_mounted) return;

        List<String> followingIds = snapshot.docs.map((doc) => doc.id).toList();

        setState(() {
          _followingUsers = followingIds;
          _isLoading = false;
          _moviePosts.clear();
          _lastDocument = null;
          _hasMore = true;
        });

        // Takip edilen kullanıcılar değiştiğinde postları yeniden yükle
        if (followingIds.isNotEmpty) {
          _fetchPosts();
        }
      }, onError: (error) {
        print("Takip etme listesi hatası: $error");
        if (_mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print("Takip edilen kullanıcıları getirme hatası: $e");
      if (_mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Takip edilen kullanıcıların postlarını getir
  Future<void> _fetchPosts() async {
    if (_isLoading || !_hasMore || !_mounted || _followingUsers.isEmpty) return;

    if (_mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // Takip edilen kullanıcıların postlarını al
      Query query = _firestore
          .collectionGroup('posts')
          .where('userId',
              whereIn: _followingUsers
                  .take(10)
                  .toList()) // Firestore 'in' sınırlaması
          .orderBy('timestamp', descending: true)
          .limit(_postLimit);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.get();

      if (!_mounted) return; // Sayfa kaldırıldıysa işlemi iptal et

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;

        List<MoviePost> newPosts = querySnapshot.docs
            .map((doc) => MoviePost.fromFirestore(doc))
            .toList();

        if (_mounted) {
          setState(() {
            _moviePosts.addAll(newPosts);
            _isLoading = false;
          });
        }
      } else {
        if (_mounted) {
          setState(() {
            _hasMore = false;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Post getirme hatası: $e");
      if (_mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Aşağı kaydırma kontrolü
  void _onScroll() {
    if (_isLoading || !_hasMore || !_mounted) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _fetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Takip Edilen Gönderiler"),
        backgroundColor: Colors.black,
      ),
      body: _followingUsers.isEmpty
          ? Center(
              child: Text(
                "Henüz kimseyi takip etmiyorsunuz.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                if (_mounted) {
                  setState(() {
                    _moviePosts.clear();
                    _lastDocument = null;
                    _hasMore = true;
                  });
                }
                await _fetchPosts();
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
