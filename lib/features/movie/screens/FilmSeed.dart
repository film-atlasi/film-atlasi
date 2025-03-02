import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:flutter/material.dart';

class FilmSeedPage extends StatefulWidget {
  const FilmSeedPage({super.key});

  @override
  State<FilmSeedPage> createState() => _FilmSeedPageState();
}

class _FilmSeedPageState extends State<FilmSeedPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<MoviePost> _moviePosts = []; // Post listesi
  bool _isLoading = false; // Yükleme durumu
  bool _hasMore = true; // Daha fazla veri var mı?
  DocumentSnapshot? _lastDocument; // Son çekilen belge referansı
  final int _postLimit = 5; // Her yüklemede kaç post çekilecek
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPosts(); // İlk veri çekme işlemi
    _scrollController.addListener(_onScroll); // Kaydırmayı dinle
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// **🔥 Firebase'den Lazy Load ile Postları Çekme**
  Future<void> _fetchPosts() async {
    if (_isLoading || !_hasMore) return; // Zaten yükleniyorsa çık

    setState(() {
      _isLoading = true;
    });

    try {
      Query query = _firestore
          .collectionGroup('posts') // 🔥 Tüm "posts" koleksiyonlarını al
          .where("source", isEqualTo: "films")
          .orderBy('timestamp', descending: true)
          .limit(_postLimit);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.get();

      if (!mounted) return; // 🚀 **Sayfa kaldırıldıysa işlemi iptal et*

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last; // Son dokümanı referans al
        _moviePosts.addAll(
            querySnapshot.docs.map((doc) => MoviePost.fromFirestore(doc)));
      } else {
        _hasMore = false; // Daha fazla veri yok
      }
    } catch (e) {
      print("Hata oluştu: $e");
    }

    if (!mounted) return; // 🚀 **Yine sayfa kaldırıldı mı kontrol et**

    setState(() {
      _isLoading = false;
    });
  }

  /// **🔥 Aşağı kaydırma kontrolü**
  void _onScroll() {
    if (_isLoading || !_hasMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _fetchPosts(); // Kullanıcı en sona yaklaştığında yeni verileri getir
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _moviePosts.clear();
          _lastDocument = null;
          _hasMore = true;
          await _fetchPosts();
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _moviePosts.length + 1, // Yükleme göstergesi için +1
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
