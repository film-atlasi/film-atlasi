import 'package:flutter/material.dart';
import 'package:film_atlasi/core/utils/helpers.dart';

class MovieInfoWidget extends StatelessWidget {
  final String releaseDate;
  final List<int>? genreIds;

  MovieInfoWidget({required this.releaseDate, required this.genreIds});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Yayınlanış Tarihi: ${Helpers.reverseDate(releaseDate)}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "Tür: ${Helpers.getGenres(genreIds)}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
