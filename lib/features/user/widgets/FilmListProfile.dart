// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FilmListProfile extends StatefulWidget {
//   final String userUid;

//   const FilmListProfile({Key? key, required this.userUid}) : super(key: key);

//   @override
//   _FilmListProfileState createState() => _FilmListProfileState();
// }

// class _FilmListProfileState extends State<FilmListProfile> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   List<Map<String, dynamic>> _userFilmLists = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserFilmLists();
//   }

//   /// **📌 Kullanıcının UID'sine Göre Film Listelerini Firestore'dan Çek**
//   void fetchUserFilmLists() async {
//     QuerySnapshot snapshot = await firestore
//         .collection("film_listeleri")
//         .where('userUid', isEqualTo: widget.userUid) // 🔥 Kullanıcının listelerini çekiyoruz.
//         .get();

//     List<Map<String, dynamic>> firebaseLists = snapshot.docs.map((doc) {
//       return {
//         "name": doc["name"],
//         "movies": (doc["movies"] as List).map((m) => {
//               "id": m["id"],
//               "title": m["title"],
//               "posterPath": m["posterPath"],
//             }).toList(),
//       };
//     }).toList();

//     setState(() {
//       _userFilmLists = firebaseLists;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? Center(child: CircularProgressIndicator(color: Colors.white))
//         : _userFilmLists.isEmpty
//             ? Center(
//                 child: Text(
//                   "Henüz hiç film listesi oluşturulmadı.",
//                   style: TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//               )
//             : ListView(
//                 children: _userFilmLists.map((list) {
//                   return Card(
//                     color: Colors.grey[900],
//                     margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     child: ExpansionTile(
//                       title: Text(list["name"], style: TextStyle(color: Colors.white, fontSize: 18)),
//                       children: [
//                         ...list["movies"].map<Widget>((movie) => ListTile(
//                               leading: movie["posterPath"] != null && movie["posterPath"].isNotEmpty
//                                   ? Image.network(
//                                       "https://image.tmdb.org/t/p/w92${movie["posterPath"]}",
//                                       width: 50,
//                                       errorBuilder: (_, __, ___) =>
//                                           const Icon(Icons.movie, color: Colors.white),
//                                     )
//                                   : const Icon(Icons.movie, color: Colors.white),
//                               title: Text(
//                                 movie["title"],
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             )),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               );
//   }
// }
