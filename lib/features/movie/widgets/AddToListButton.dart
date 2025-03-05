import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';

class AddToListButton extends StatefulWidget {
  final Movie movie;

  const AddToListButton({super.key, required this.movie});

  @override
  _AddToListButtonState createState() => _AddToListButtonState();
}

class _AddToListButtonState extends State<AddToListButton> {
  List<Map<String, dynamic>> _savedLists = [];
  bool isLoading = true;
  final TextEditingController _listNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserLists();
  }

  /// **Firebase'den Kullanıcının Listelerini Çek**
  void fetchUserLists() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("film_listeleri")
        .where("userId", isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> firebaseLists = snapshot.docs.map((doc) {
      return {
        "name": doc["name"],
        "userId": doc["userId"],
        "movies": (doc["movies"] as List)
      };
    }).toList();

    setState(() {
      _savedLists = firebaseLists;
      isLoading = false;
    });
  }

  /// **Seçilen Listeye Film Ekle**
  void addMovieToList(String listName) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    DocumentReference listRef =
        FirebaseFirestore.instance.collection("film_listeleri").doc(listName);
    DocumentSnapshot snapshot = await listRef.get();

    if (snapshot.exists) {
      List<dynamic> movieList = snapshot["movies"];

      bool alreadyExists = movieList.any((m) => m["id"] == widget.movie.id);
      if (alreadyExists) {
        Navigator.pop(context);
        _showSnackbar("Bu film zaten \"$listName\" listesinde var!");
        return;
      }

      movieList.add({
        "id": widget.movie.id,
        "title": widget.movie.title,
        "overview": widget.movie.overview,
        "posterPath": widget.movie.posterPath,
        "voteAverage": widget.movie.voteAverage,
      });

      await listRef.update({"movies": movieList});
      Navigator.pop(context);
      _showSnackbar("Film \"$listName\" listesine eklendi!");
    }
  }

  /// **Yeni Liste Oluştur ve Filmi Ekle**
  void createNewListAndAddMovie() async {
    String listName = _listNameController.text.trim();
    if (listName.isEmpty) return;

    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    DocumentReference newListRef =
        FirebaseFirestore.instance.collection("film_listeleri").doc(listName);

    await newListRef.set({
      "name": listName,
      "userId": userId,
      "movies": [
        {
          "id": widget.movie.id,
          "title": widget.movie.title,
          "overview": widget.movie.overview,
          "posterPath": widget.movie.posterPath,
          "voteAverage": widget.movie.voteAverage,
        }
      ],
    });

    setState(() {
      _savedLists.add({"name": listName, "userId": userId, "movies": []});
    });

    Navigator.pop(context);
    _showSnackbar("Yeni liste oluşturuldu: \"$listName\"");
  }

  /// **Snackbar Mesajı**
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  /// **Liste Seçim Penceresini Aç**
  void _showListSelectionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Film Listesine Ekle",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _savedLists.isEmpty
                  ? Column(
                      children: [
                        Text(
                            "Henüz bir listeniz yok, yeni bir liste oluşturun."),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _listNameController,
                          decoration: InputDecoration(
                            hintText: "Liste adı girin",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: createNewListAndAddMovie,
                          child: Text("Liste Oluştur ve Ekle"),
                        ),
                      ],
                    )
                  : Column(
                      children: _savedLists.map((list) {
                        return ListTile(
                          title: Text(list["name"]),
                          onTap: () => addMovieToList(list["name"]),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("İptal"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _showListSelectionDialog,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.highlightColor,
        padding:
            EdgeInsets.all(8), // Küçük padding, etrafındaki alanı küçültüyor
        minimumSize: Size(40, 40), // Butonun minimum boyutunu küçült
        shape: CircleBorder(), // Butonu yuvarlak hale getir
      ),
      child: Icon(Icons.playlist_add,
          size: 20, color: AppConstants.textColor), // Sadece ikon
    );
  }
}
