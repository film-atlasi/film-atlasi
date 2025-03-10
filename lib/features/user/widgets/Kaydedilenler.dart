import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/widgets/LoadingWidget.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/user/services/KaydetServices.dart';
import 'package:flutter/material.dart';

class Kaydedilenler extends StatefulWidget {
  final String userUid;
  const Kaydedilenler({super.key, required this.userUid});

  @override
  State<Kaydedilenler> createState() => _KaydedilenlerState();
}

class _KaydedilenlerState extends State<Kaydedilenler> {
  final KaydetServices _kaydetServices = KaydetServices();
  List<MoviePost> _kaydedilenler = [];
  bool isLoading = false;
  DocumentSnapshot? lastDocument;
  static const int _postLimit = 5;

  @override
  void initState() {
    super.initState();
    _loadInitialSavedPosts();
  }

  // **📌 İlk Kaydedilen Postları Yükle**
  Future<void> _loadInitialSavedPosts() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    final kaydedilenler = await _kaydetServices.getKaydedilenler();

    if (!mounted) return;
    setState(() {
      _kaydedilenler = kaydedilenler;
      lastDocument = kaydedilenler.isNotEmpty ? kaydedilenler.last.documentSnapshot : null;
      isLoading = false;
    });
  }

  // **📌 Daha Fazla Kaydedilen Post Yükle**
  Future<void> _loadMoreSavedPosts() async {
    if (isLoading || lastDocument == null) return;

    setState(() => isLoading = true);

    var query = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userUid)
        .collection("saved_posts") // 🔥 Kaydedilen postlar koleksiyonu
        .orderBy("timestamp", descending: true)
        .startAfterDocument(lastDocument!)
        .limit(_postLimit);

    var snapshot = await query.get();
    var newPosts = snapshot.docs.map((doc) => MoviePost.fromDocument(doc)).toList();

    if (!mounted) return;
    setState(() {
      if (newPosts.isNotEmpty) {
        _kaydedilenler.addAll(newPosts);
        lastDocument = snapshot.docs.last;
      } else {
        lastDocument = null;
      }
      isLoading = false;
    });
  }

  // **📌 Sayfayı Aşağı Çekerek Yenileme**
  Future<void> _refreshSavedPosts() async {
    setState(() {
      _kaydedilenler.clear(); // Eski verileri temizle
      lastDocument = null; // Son dokümanı sıfırla
    });
    await _loadInitialSavedPosts(); // Yeniden yükle
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshSavedPosts, // 🛠 Sayfa yenilendiğinde çalışacak fonksiyon
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent - 300) {
            _loadMoreSavedPosts();
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == _kaydedilenler.length) {
                    return isLoading
                        ? LoadingWidget()
                        : const SizedBox.shrink();
                  }
                  return MoviePostCard(
                    moviePost: _kaydedilenler[index],
                  );
                },
                childCount: _kaydedilenler.length + (isLoading ? 1 : 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
