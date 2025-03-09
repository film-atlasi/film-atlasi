import 'package:film_atlasi/features/movie/services/FilmListService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';

class FilmList extends StatefulWidget {
  final Movie? selectedMovie;

  const FilmList({super.key, this.selectedMovie});

  @override
  _FilmListState createState() => _FilmListState();
}

class _FilmListState extends State<FilmList> {
  final TextEditingController _listNameController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FilmListService filmListService = FilmListService();
  List<Map<String, dynamic>> _savedLists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchListsFromFirestore();
  }

  /// **Firebase'den Kayıtlı Listeleri Çek**
  void fetchListsFromFirestore() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    QuerySnapshot snapshot = await firestore
        .collection("film_listeleri")
        .where("userId", isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> firebaseLists = snapshot.docs.map((doc) {
      return {
        "name": doc["name"],
        "userId": doc["userId"],
        "movies": (doc["movies"] as List)
            .map((m) => Movie(
                  id: m["id"] ?? "",
                  title: m["title"] ?? "Bilinmeyen Film",
                  overview: m["overview"] ?? "",
                  posterPath: m["posterPath"] ?? "",
                  voteAverage: m["voteAverage"] ?? 0.0,
                ))
            .toList(),
      };
    }).toList();

    setState(() {
      _savedLists = firebaseLists;
      isLoading = false;
    });
  }

  /// **Yeni Liste Oluştur ve Firebase'e Kaydet**
  void _createNewList() {
    if (_listNameController.text.isNotEmpty) {
      String listName = _listNameController.text.trim();
      if (listName.isEmpty) return;

      Map<String, dynamic> newList = {
        "name": listName,
        "movies": widget.selectedMovie != null ? [widget.selectedMovie!] : [],
        "userId": FirebaseAuth.instance.currentUser?.uid ?? "",
      };

      setState(() {
        _savedLists.add(newList);
      });

      filmListService.saveListToFirestore(listName, newList["movies"]);
      _listNameController.clear();

      _showSnackbar("Yeni liste oluşturuldu: \"$listName\"");
    }
  }

  /// **Mevcut Listeye Film Ekleme**
  void _addMovieToList(int index) {
    if (widget.selectedMovie == null) return;

    bool alreadyExists = _savedLists[index]["movies"]
        .any((movie) => movie.id == widget.selectedMovie!.id);

    if (alreadyExists) {
      _showSnackbar(
          "Bu film zaten \"${_savedLists[index]["name"]}\" listesinde var!");
      return;
    }

    setState(() {
      _savedLists[index]["movies"].add(widget.selectedMovie!);
    });

    filmListService.addMovieToFirestore(
        _savedLists[index]["name"], widget.selectedMovie!);
    _showSnackbar("Film \"${_savedLists[index]["name"]}\" listesine eklendi!");
  }

  /// **Listeden Film Silme**
  void _removeMovieFromList(int listIndex, Movie movie) {
    setState(() {
      _savedLists[listIndex]["movies"].remove(movie);
    });

    filmListService.removeMovieFromFirestore(
        _savedLists[listIndex]["name"], movie);
    _showSnackbar("\"${movie.title}\" listeden kaldırıldı!");
  }

  /// **Listeyi Silme**
  void _deleteList(int index) {
    String listName = _savedLists[index]["name"];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Listeyi Sil"),
          content:
              Text("\"$listName\" listesini silmek istediğinize emin misiniz?"),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Evet", style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _savedLists.removeAt(index);
                });

                filmListService.deleteListFromFirestore(listName);
                Navigator.of(context).pop();
                _showSnackbar("Liste silindi: \"$listName\"");
              },
            ),
          ],
        );
      },
    );
  }

  /// **Snackbar Geri Bildirim Mesajı**
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Listelerim"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: _savedLists.map((list) {
                      int index = _savedLists.indexOf(list);
                      return Card(
                        child: ExpansionTile(
                          title: Text(list["name"],
                              style: TextStyle(fontSize: 18)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add,
                                    color: const Color.fromARGB(
                                        255, 133, 129, 129)),
                                onPressed: () => _addMovieToList(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color:
                                        const Color.fromARGB(255, 105, 21, 15)),
                                onPressed: () => _deleteList(index),
                              ),
                            ],
                          ),
                          children: [
                            ...list["movies"].map<Widget>((movie) => ListTile(
                                  leading: movie.posterPath != null &&
                                          movie.posterPath!.isNotEmpty
                                      ? Image.network(
                                          "https://image.tmdb.org/t/p/w92${movie.posterPath}",
                                          width: 50,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.movie,),
                                        )
                                      : const Icon(
                                          Icons.movie,
                                        ),
                                  title: Text(
                                    movie.title,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.remove_circle,
                                        color: const Color.fromARGB(
                                            255, 100, 15, 9)),
                                    onPressed: () =>
                                        _removeMovieFromList(index, movie),
                                  ),
                                )),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _listNameController,
                    decoration: InputDecoration(
                      hintText: 'Yeni liste...',
                      filled: true,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _createNewList,
                  child: Text("Yeni Liste Oluştur"),
                ),
              ],
            ),
    );
  }
}
