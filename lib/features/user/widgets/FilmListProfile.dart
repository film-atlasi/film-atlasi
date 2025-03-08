import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/widgets/FilmBilgiWidget.dart';
import 'package:flutter/material.dart';

class FilmListProfile extends StatefulWidget {
  final String userUid;

  const FilmListProfile({super.key, required this.userUid});

  @override
  _FilmListProfileState createState() => _FilmListProfileState();
}

class _FilmListProfileState extends State<FilmListProfile> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _userFilmLists = [];
  final Map<String, List<Map<String, dynamic>>?> _moviesMap = {};
  final Map<String, bool> _loadingStatus = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserFilmLists();
  }

  /// **🔥 Kullanıcının film listelerini getirir**
  Future<void> fetchUserFilmLists({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _userFilmLists.clear();
        _moviesMap.clear();
        _loadingStatus.clear();
      });
    }

    setState(() => isLoading = true);

    QuerySnapshot snapshot = await firestore
        .collection("film_listeleri")
        .where('userId', isEqualTo: widget.userUid)
        .get();

    List<Map<String, dynamic>> firebaseLists = snapshot.docs.map((doc) {
      return {
        "id": doc.id,
        "name": doc["name"],
        "lastFourMovies": doc["movies"].length > 4
            ? doc["movies"].sublist(0, 4)
            : doc["movies"],
      };
    }).toList();

    setState(() {
      _userFilmLists = firebaseLists;
      isLoading = false;
    });
  }

  /// **🔥 Belirli bir listeye ait filmleri getirir**
  void fetchMoviesForList(String listId) async {
    if (_moviesMap[listId] != null) return;

    setState(() {
      _loadingStatus[listId] = true;
    });

    DocumentSnapshot doc =
        await firestore.collection("film_listeleri").doc(listId).get();
    List<Map<String, dynamic>> movies = (doc["movies"] as List).map((m) {
      return {
        "id": m["id"],
        "title": m["title"],
        "posterPath": m["posterPath"],
      };
    }).toList();

    setState(() {
      _moviesMap[listId] = movies;
      _loadingStatus[listId] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await fetchUserFilmLists(isRefresh: true);
      },
      child: Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.redAccent))
            : _userFilmLists.isEmpty
                ? const Center(
                    child: Text(
                      "Henüz hiç film listesi oluşturulmadı.",
                    ),
                  )
                : ListView.builder(
                    itemCount: _userFilmLists.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> filmList = _userFilmLists[index];
                      String listId = filmList["id"];
                      List<dynamic>? lastFourMovies = filmList["lastFourMovies"];

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: ExpansionTile(
                          title: Text(
                            filmList["name"].toString().toUpperCase(),
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              if (lastFourMovies != null)
                                ...lastFourMovies.map((movie) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: movie["posterPath"] != null &&
                                              movie["posterPath"].isNotEmpty
                                          ? Image.network(
                                              "https://image.tmdb.org/t/p/w200${movie["posterPath"]}",
                                              width: 20,
                                              height: 30,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  width: 50,
                                                  height: 70,
                                                  color: Colors.grey.shade800,
                                                  child: const Icon(
                                                    Icons.movie,
                                                    color: Colors.white70,
                                                    size: 30,
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              width: 50,
                                              height: 70,
                                              color: Colors.grey.shade800,
                                              child: const Icon(
                                                Icons.movie,
                                                color: Colors.white70,
                                                size: 30,
                                              ),
                                            ),
                                    ),
                                  );
                                }),
                            ],
                          ),
                          onExpansionChanged: (isExpanded) {
                            if (isExpanded) {
                              fetchMoviesForList(listId);
                            }
                          },
                          children: [
                            if (_loadingStatus[listId] == true)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.redAccent)),
                              )
                            else if (_moviesMap[listId] == null ||
                                _moviesMap[listId]!.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text(
                                    "Bu listede henüz film yok.",
                                  ),
                                ),
                              )
                            else
                              Column(
                                children: _moviesMap[listId]!.map((movie) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FilmBilgiWidget(
                                      movieId: movie["id"],
                                      oyuncular: false,
                                      posterHeight: 100,
                                    ),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
