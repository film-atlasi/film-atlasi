import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FilmAraWidget(mode: "film_incele"),
          ),
        );
      },
      child: Container(
        height: 56,
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search,
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
            const SizedBox(width: 12),
            Text(
              "Film veya dizi ara...",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
