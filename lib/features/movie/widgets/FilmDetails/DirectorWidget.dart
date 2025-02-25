import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/Actor.dart';
import 'package:film_atlasi/features/movie/screens/ActorMoviesPage.dart';

class DirectorWidget extends StatelessWidget {
  final Actor director;

  const DirectorWidget({super.key, required this.director});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          director.name.isNotEmpty ? director.name : "Yönetmen Bilinmiyor",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActorMoviesPage(
                    actorName: director.name, actorId: director.id),
              ),
            );
          },
          child: CircleAvatar(
            radius: 30,
            backgroundImage: director.profilePhotoUrl != null
                ? NetworkImage(director.profilePhotoUrl!)
                : null,
            backgroundColor: Colors.grey,
            child: director.profilePhotoUrl == null
                ? Icon(Icons.person, color: Colors.white, size: 30)
                : null,
          ),
        ),
      ],
    );
  }
}
