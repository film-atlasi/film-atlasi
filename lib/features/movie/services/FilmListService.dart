import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FilmListService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addMovieToFirestore(String listName, Movie movie) async {
    DocumentReference listRef =
        FirebaseFirestore.instance.collection("film_listeleri").doc(listName);
    DocumentSnapshot snapshot = await listRef.get();

    if (snapshot.exists) {
      // Mevcut film listesini al
      List<dynamic> movieList = List.from(snapshot["movies"]);

      // Eğer film zaten varsa ekleme
      bool alreadyExists = movieList.any((m) => m["id"] == movie.id);
      if (alreadyExists) return;

      // Yeni filmi `movies` listesine ekle
      movieList.add({
        "id": movie.id,
        "title": movie.title,
        "overview": movie.overview,
        "posterPath": movie.posterPath,
        "voteAverage": movie.voteAverage,
      });

      // **Son 4 filmi `lastFourMovies` olarak güncelle**
      List<Map<String, dynamic>> lastFourMovies =
          movieList.reversed // Listeyi ters çevir (son eklenenler başa gelsin)
              .take(4) // Son 4 filmi al
              .map((m) => {
                    "id": m["id"],
                    "posterPath": m["posterPath"],
                  })
              .toList();

      // Firestore güncellemesi
      await listRef.update({
        "movies": movieList,
        "lastFourMovies": lastFourMovies, // Son 4 filmi kaydet
      });
    }
  }

  Future<void> removeMovieFromFirestore(String listName, Movie movie) async {
    DocumentReference listRef =
        firestore.collection("film_listeleri").doc(listName);
    DocumentSnapshot snapshot = await listRef.get();

    if (snapshot.exists) {
      List<dynamic> movieList = (snapshot["movies"] as List)
          .where((m) => m["id"] != movie.id)
          .toList();

      await listRef.update({"movies": movieList});
    }
  }

  Future<void> deleteListFromFirestore(String listName) async {
    await firestore.collection("film_listeleri").doc(listName).delete();
  }

  Future<void> saveListToFirestore(String listName, List<Movie> movies) async {
    await firestore.collection("film_listeleri").doc(listName).set({
      "name": listName,
      "userId": FirebaseAuth.instance.currentUser?.uid ?? "",
      "movies": movies
          .map((movie) => {
                "id": movie.id,
                "title": movie.title,
                "overview": movie.overview,
                "posterPath": movie.posterPath,
                "voteAverage": movie.voteAverage,
              })
          .toList(),
    });
  }

  Future<void> createNewListAndAddMovie(String name, Movie movie) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    DocumentReference newListRef =
        FirebaseFirestore.instance.collection("film_listeleri").doc(name);

    await newListRef.set({
      "name": name,
      "userId": userId,
      "movies": [
        {
          "id": movie.id,
          "title": movie.title,
          "overview": movie.overview,
          "posterPath": movie.posterPath,
          "voteAverage": movie.voteAverage,
        }
      ],
    });
  }
}
