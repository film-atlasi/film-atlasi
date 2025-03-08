import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/widgets/MoviePostCard.dart';
import 'package:film_atlasi/features/user/services/KaydetServices.dart';
import 'package:flutter/material.dart';

class Kaydedilenler extends StatefulWidget {
  const Kaydedilenler({super.key});

  @override
  State<Kaydedilenler> createState() => _KaydedilenlerState();
}

class _KaydedilenlerState extends State<Kaydedilenler> {
  final KaydetServices _kaydetServices = KaydetServices();
  final ScrollController _scrollController = ScrollController();
  List<MoviePost> _kaydedilenler = [];
  DocumentSnapshot? _lastDoc;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchKaydedilenler();
    _scrollController.addListener(_onScroll);
  }

  /// **🔥 Kaydedilen postları getirir**
  Future<void> _fetchKaydedilenler({bool isRefresh = false}) async {
    if (_isLoading || (!_hasMore && !isRefresh)) return;

    if (isRefresh) {
      setState(() {
        _kaydedilenler.clear();
        _lastDoc = null;
        _hasMore = true;
      });
    }

    setState(() => _isLoading = true);

    final List<MoviePost> newKaydedilenler =
        await _kaydetServices.getKaydedilenler(lastDoc: _lastDoc);

    setState(() {
      _kaydedilenler.addAll(newKaydedilenler);
      _lastDoc = newKaydedilenler.isNotEmpty
          ? newKaydedilenler.last.documentSnapshot
          : null;
      _isLoading = false;
      _hasMore = newKaydedilenler.length == 5;
    });
  }

  /// **🔥 Sonsuz kaydırma için ek veri yükleme**
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _fetchKaydedilenler();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _fetchKaydedilenler(isRefresh: true);
      },
      child: _kaydedilenler.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _kaydedilenler.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _kaydedilenler.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return MoviePostCard(moviePost: _kaydedilenler[index]);
              },
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
