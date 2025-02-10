
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/screens/ActorMoviesPage.dart';
import 'package:flutter/material.dart';

class OyuncuCircleAvatar extends StatelessWidget {
  final Actor actor;
  const OyuncuCircleAvatar({
    super.key,
    required this.actor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ActorMoviesPage(
              actorName: actor.name,
              actorId: actor.id,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 3.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: actor
                          .profilePhotoUrl !=
                      null
                  ? NetworkImage(
                      actor.profilePhotoUrl!)
                  : null,
              backgroundColor: Colors.grey,
              radius: 20,
              child: actor.profilePhotoUrl ==
                      null
                  ? Icon(Icons.person,
                      color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 3),
            Text(
              actor.name,
              style: const TextStyle(
                  fontSize: 8),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
