import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/screens/ActorMoviesPage.dart';

class PersonSearchResults extends StatelessWidget {
  final List<dynamic> searchResults;
  final String mode; // "list" veya "grid"

  const PersonSearchResults({super.key, required this.searchResults, required this.mode});

  @override
  Widget build(BuildContext context) {
    return mode == "grid"
        ? GridView.builder(
            itemCount: searchResults.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) => buildPersonCard(context, searchResults[index]),
          )
        : ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) => buildPersonCard(context, searchResults[index]),
          );
  }

  Widget buildPersonCard(BuildContext context, dynamic person) {
    return ListTile(
      leading: person['profile_path'] != null
          ? Image.network("https://image.tmdb.org/t/p/w200${person['profile_path']}")
          : const Icon(Icons.person, color: Colors.grey),
      title: Text(person['name'] ?? "Bilinmeyen", style: const TextStyle(color: Colors.white)),
      subtitle: Text(person['known_for_department'] ?? "Bilinmeyen", style: const TextStyle(color: Colors.grey)),
      onTap: () {
        if (person['id'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActorMoviesPage(
                actorName: person['name'] ?? "Bilinmeyen",
                actorId: person['id'],
              ),
            ),
          );
        }
      },
    );
  }
}
