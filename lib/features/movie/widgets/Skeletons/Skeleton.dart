import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget skeleton(double height, double width, double borderRadius,
    BuildContext context) {
    final AppConstants appConstants = AppConstants(context);
  return Shimmer.fromColors(
    baseColor: appConstants.textColor,
    highlightColor: appConstants.textLightColor,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: appConstants.textColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
}
