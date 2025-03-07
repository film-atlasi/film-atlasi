import 'package:flutter/material.dart';

class SpoilerWidget extends StatefulWidget {
  final String content;

  const SpoilerWidget({super.key, required this.content});

  @override
  _SpoilerWidgetState createState() => _SpoilerWidgetState();
}

class _SpoilerWidgetState extends State<SpoilerWidget> {
  bool isRevealed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isRevealed = true),
      child: Container(
        width: double.infinity, // ✅ Ekran genişliğine göre ayarla
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.85, // ✅ Maksimum genişliği ekranın %85'i kadar yap
        ),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isRevealed ? Colors.transparent : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: isRevealed
            ? Text(widget.content, style: const TextStyle(color: Colors.white))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.visibility_off, color: Colors.white70),
                  SizedBox(width: 8),
                  Expanded(
                    // ✅ Taşmayı engellemek için eklendi
                    child: Text(
                      'Spoiler İçerik – Görmek için dokunun',
                      style: TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis, // ✅ Taşmayı engelle
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
