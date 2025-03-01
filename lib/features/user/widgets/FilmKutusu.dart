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
  bool isLoading = false; // 🔥 Yeni verileri yüklerken animasyon gösterecek
  DocumentSnapshot? lastDocument; // 🔥 Sayfa kaydırıldığında kaldığımız yer

  final ScrollController _scrollController = ScrollController();
  static const int _postLimit = 5; // 📌 Her seferde kaç post çekeceğiz?

  @override
  void initState() {
    super.initState();
    isCurrentUser = UserServices.currentUserUid == widget.userUid;
    _loadInitialPosts(); // 📌 İlk verileri çekiyoruz

    // 🔥 Lazy Load için scroll dinleyicisi ekliyoruz
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        _loadMorePosts(); // 📌 Kullanıcı en alta geldiğinde yeni postları yükle
      }
    });
  }

  Future<void> _loadInitialPosts() async {
    if (!mounted) return; // 🚀 **Yine sayfa kaldırıldı mı kontrol et**

    setState(() {
      isLoading = true;
    });

    var query = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userUid)
        .collection("posts")
        .orderBy("timestamp", descending: true)
        .limit(_postLimit);

    var snapshot = await query.get();

    posts = snapshot.docs.map((doc) => MoviePost.fromDocument(doc)).toList();
    lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    if (!mounted) return; // 🚀 **Yine sayfa kaldırıldı mı kontrol et**

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadMorePosts() async {
    if (isLoading || lastDocument == null) return;
    if (!mounted) return; // 🚀 **Yine sayfa kaldırıldı mı kontrol et**

    setState(() {
      isLoading = true;
    });

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
      lastDocument = null; // 🔥 Daha fazla veri yoksa yükleme duracak
    }

    if (!mounted) return; // 🚀 **Yine sayfa kaldırıldı mı kontrol et**

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return posts.isEmpty && isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: _scrollController,
            itemCount: posts.length +
                (isLoading
                    ? 1
                    : 0), // 🔥 Yükleme göstergesi için ekstra 1 ekliyoruz
            itemBuilder: (context, index) {
              if (index == posts.length) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // 📌 Lazy Load sırasında alt kısımda yükleme göstergesi
              }
              return MoviePostCard(
                moviePost: posts[index],
                isOwnPost: posts[index].userId == UserServices.currentUserUid,
              );
            },
          );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
