import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/screens/ActorMoviesPage.dart';

class PersonSearchResults extends StatelessWidget {
  final List<dynamic> searchResults;
  final String mode; // "list" veya "grid"

  const PersonSearchResults({super.key, required this.searchResults, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: GridView.builder(
        itemCount: searchResults.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 sütunlu grid
          crossAxisSpacing: 8, // Yatay boşluk azaldı
          mainAxisSpacing: 12, // Dikey boşluk ayarlandı
          childAspectRatio: 0.6, // Daha uzun dikdörtgen görünüm için oran değiştirildi
        ),
        itemBuilder: (context, index) => buildPersonCard(context, searchResults[index]),
      ),
    );
  }

  Widget buildPersonCard(BuildContext context, dynamic person) {
    return GestureDetector(
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
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12), // Hafif köşeleri yuvarlatılmış dikdörtgen
            child: person['profile_path'] != null
                ? Image.network(
                    "https://image.tmdb.org/t/p/w400${person['profile_path']}",
                    width: 160, // Daha geniş
                    height: 240, // Daha uzun
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 160,
                      height: 240,
                      color: Colors.grey[800],
                      child: const Icon(Icons.person, size: 80, color: Colors.white),
                    ),
                  )
                : Container(
                    width: 160,
                    height: 240,
                    color: Colors.grey[800],
                    child: const Icon(Icons.person, size: 80, color: Colors.white),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            person['name'] ?? "Bilinmeyen",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            person['known_for_department'] ?? "Bilinmeyen",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}