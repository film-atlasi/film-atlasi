import 'package:flutter/material.dart';

class PlatformWidget extends StatelessWidget {
  final Map<String, String> watchProvidersWithIcons;

  PlatformWidget({required this.watchProvidersWithIcons});

  @override
  Widget build(BuildContext context) {
    if (watchProvidersWithIcons.isEmpty) return SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Bu platformdan izleyebilirsiniz:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: watchProvidersWithIcons.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.network(
                    entry.value,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
