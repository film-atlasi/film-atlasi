import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

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
    final AppConstants appConstants = AppConstants(context);
    return GestureDetector(
      onTap: () => setState(() => isRevealed = true),
      child: Container(
        decoration: BoxDecoration(
            border: isRevealed
                ? null
                : Border.all(color: appConstants.backgroundColor),
            borderRadius: BorderRadius.circular(18)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                ),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isRevealed
                      ? widget.content
                      : 'Spoiler İçerik ${widget.content} – Görmek için dokunun ${widget.content}',
                  maxLines: isRevealed ? 5 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!isRevealed)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.visibility_off),
                            SizedBox(width: 8),
                            Text(
                              'Spoiler İçerik – Görmek için dokunun',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
