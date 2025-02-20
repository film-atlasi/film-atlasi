import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingDisplayWidget extends StatelessWidget {
  final double rating;

  const RatingDisplayWidget({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating, // Kullanıcının verdiği puanı göster
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber, // Yıldız rengi sarı
      ),
      itemCount: 5, // Toplam 5 yıldız olacak
      itemSize: 17, // Yıldızların boyutu (isteğe göre artırılabilir)
      direction: Axis.horizontal, // Yatay dizilim
    );
  }
}
