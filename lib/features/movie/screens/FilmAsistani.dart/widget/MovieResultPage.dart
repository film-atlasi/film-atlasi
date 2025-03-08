// import 'package:film_atlasi/features/movie/screens/FilmAsistani.dart/widget/MovieResultPage.dart';
// import 'package:film_atlasi/features/movie/services/MovieServices.dart';
// import 'package:flutter/material.dart';
// import 'package:film_atlasi/features/movie/models/Movie.dart';

// class MovieResultsPage extends StatelessWidget {
//   final List<Movie> movies;
//   MovieResultsPage({required this.movies});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text("Önerilen Filmler"),
//         backgroundColor: Colors.black,
//       ),
//       body: ListView.builder(
//         itemCount: movies.length,
//         itemBuilder: (context, index) {
//           final movie = movies[index];

//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[900], // Koyu arka plan
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   // Film Afişi
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       "https://image.tmdb.org/t/p/w200${movie.posterPath}",
//                       width: 100,
//                       height: 150,
//                       fit: BoxFit.cover,
//                     ),
//                   ),

//                   SizedBox(width: 12), // Boşluk

//                   // Film Bilgileri
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             movie.title,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),

//                           SizedBox(height: 5),

//                           // Tür & Yıl
//                           Text(
//                             "Dizi • ${movie.genreIds?.join(", ")} • ${movie.releaseDate?.split("-")[0] ?? 'Bilinmiyor'}",
//                             style: TextStyle(color: Colors.grey[400]),
//                           ),

//                           SizedBox(height: 5),

//                           // IMDb Puanı
//                           Row(
//                             children: [
//                               Icon(Icons.star, color: Colors.yellow, size: 18),
//                               SizedBox(width: 5),
//                               Text(
//                                 "${movie.voteAverage}/10",
//                                 style: TextStyle(
//                                   color: Colors.yellow,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),

//                           SizedBox(height: 5),

//                           // Açıklama
//                           Text(
//                             movie.overview,
//                             style: TextStyle(color: Colors.grey[400]),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
