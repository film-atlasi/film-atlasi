import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:flutter/material.dart';

class ChatBG extends StatelessWidget {
  final Widget child;
  final Map<String, dynamic>? themeData;
  const ChatBG({super.key, required this.child, required this.themeData});

  final String baseImageUrl = "https://image.tmdb.org/t/p/w500";

  @override
  Widget build(BuildContext context) {
    if (themeData == null) {
      return Container(
        decoration: BoxDecoration(
            color: AppConstants(context).scaffoldColor), // default background
        child: child,
      );
    }

    final data = themeData!["themeData"] as Map<String, dynamic>?;

    final String type = data!['type'];
    final String urlPart = data['url'];

    ImageProvider backgroundImage;

    if (type == "film") {
      backgroundImage = NetworkImage("$baseImageUrl$urlPart");
    } else if (type == "asset") {
      backgroundImage = AssetImage("assets/images/$urlPart");
    } else {
      return Container(
        decoration: BoxDecoration(color: AppConstants(context).scaffoldColor),
        child: child,
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: backgroundImage,
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
