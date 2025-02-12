import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/screens/ActorMoviesPage.dart';
import 'package:flutter/material.dart';

class OyuncuCircleAvatar extends StatelessWidget {
  final Actor actor;
  final double radius; // Double olarak güncellendi

  const OyuncuCircleAvatar({
    super.key,
    required this.actor,
    this.radius = 25.0, // Varsayılan değer eklendi
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActorMoviesPage(
              actorName: actor.name,
              actorId: actor.id,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: actor.profilePhotoUrl != null
                  ? NetworkImage(actor.profilePhotoUrl!)
                  : null,
              backgroundColor: Colors.grey,
              radius: radius, // Parametre olarak verilen radius kullanıldı
              child: actor.profilePhotoUrl == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 3),
            Text(
              actor.name,
              style: const TextStyle(fontSize: 8),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
