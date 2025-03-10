import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';

class EditFilmListBottomSheet extends StatefulWidget {
  final String listId;
  final String initialListName;
  final List<Movie> initialMovies;
  final VoidCallback onSave;

  const EditFilmListBottomSheet({
    super.key,
    required this.listId,
    required this.initialListName,
    required this.initialMovies,
    required this.onSave,
  });

  @override
  _EditFilmListBottomSheetState createState() =>
      _EditFilmListBottomSheetState();
}

class _EditFilmListBottomSheetState extends State<EditFilmListBottomSheet> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late TextEditingController _listNameController;
  late List<Movie> _editedMovies;

  @override
  void initState() {
    super.initState();
    _listNameController = TextEditingController(text: widget.initialListName);
    _editedMovies = List.from(widget.initialMovies);
  }

  /// **🔥 Firestore'da Listeyi Güncelleme**
  Future<void> _saveChanges() async {
    if (_listNameController.text.isEmpty) return;

    await firestore.collection("film_listeleri").doc(widget.listId).update({
      "name": _listNameController.text,
      "movies": _editedMovies.map((m) => m.toJson()).toList(),
    });

    widget.onSave();
    Navigator.pop(context);
  }

  /// **🔥 Film Listeden Kaldırma**
  void _removeMovie(Movie movie) {
    setState(() {
      _editedMovies.remove(movie);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .scaffoldBackgroundColor, // 🎨 Ana temayla aynı arka plan rengi
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Text(
            "Listeyi Düzenle",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color, // 🎨 Ana temaya uygun renk
            ),
          ),
          const SizedBox(height: 10),

          // Liste Adı
          TextField(
            controller: _listNameController,
            decoration: InputDecoration(
              labelText: "Liste Adı",
              labelStyle: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color, // 🎨 Label rengi
              ),
              filled: true,
              fillColor: Theme.of(context)
                  .cardColor, // 🎨 Açık temada beyaz, koyu temada gri
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: TextStyle(
              color:
                  Theme.of(context).textTheme.bodyLarge!.color, // 🎨 Yazı rengi
            ),
          ),

          const SizedBox(height: 15),

          // Filmler Listesi
          Expanded(
            child: ListView.builder(
              itemCount: _editedMovies.length,
              itemBuilder: (context, index) {
                final movie = _editedMovies[index];
                return ListTile(
                  leading: movie.posterPath.isNotEmpty
                      ? Image.network(
                          "https://image.tmdb.org/t/p/w92${movie.posterPath}",
                          width: 50,
                          errorBuilder: (_, __, ___) => const Icon(Icons.movie),
                        )
                      : const Icon(Icons.movie),
                  title: Text(
                    movie.title,
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color, // 🎨 Metin rengi
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeMovie(movie),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Kaydet Butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.redAccent, // 🎨 Film Atlası temasına uygun renk
                foregroundColor: Colors.white,
              ),
              onPressed: _saveChanges,
              child: const Text("Kaydet"),
            ),
          ),
        ],
      ),
    );
  }
}
