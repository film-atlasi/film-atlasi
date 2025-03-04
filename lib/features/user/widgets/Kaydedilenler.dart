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

  Future<void> _fetchKaydedilenler() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
    });

    final List<MoviePost> newKaydedilenler =
        await _kaydetServices.getKaydedilenler(
      lastDoc: _lastDoc,
    );

    setState(() {
      _kaydedilenler.addAll(newKaydedilenler);
      _lastDoc = newKaydedilenler.isNotEmpty
          ? newKaydedilenler.last.documentSnapshot
          : null;
      _isLoading = false;
      _hasMore = newKaydedilenler.length == 10;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchKaydedilenler();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _kaydedilenler.isEmpty && _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: _scrollController,
            itemCount: _kaydedilenler.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _kaydedilenler.length) {
                return Center(child: CircularProgressIndicator());
              }
              return MoviePostCard(moviePost: _kaydedilenler[index]);
            },
          );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
