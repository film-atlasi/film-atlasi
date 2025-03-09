import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget skeleton(double height, double width, double borderRadius,
    Color baseColor, Color highlightColor) {
  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
}
