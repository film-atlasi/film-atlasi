import 'package:flutter/material.dart';

class IMDBWidget extends StatelessWidget {
  final double voteAverage;

  IMDBWidget({required this.voteAverage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.white, size: 18),
          SizedBox(width: 4),
          Text(
            voteAverage.toStringAsFixed(1),
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
