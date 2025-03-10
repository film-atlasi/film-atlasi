import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/widgets/Skeletons/Skeleton.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget FilmBilgiSkeleton(AppConstants appConstants, BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      skeleton(180, 140, 10, context),
      AddHorizontalSpace(context, 0.01),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          skeleton(15, appConstants.getWidth(0.4), 10, context),
          AddVerticalSpace(context, 0.01),
          skeleton(10, appConstants.getWidth(0.5), 0, context),
          AddVerticalSpace(context, 0.007),
          skeleton(10, appConstants.getWidth(0.5), 0, context),
          AddVerticalSpace(context, 0.007),
          skeleton(10, appConstants.getWidth(0.5), 0, context),
          AddVerticalSpace(context, 0.007),
          skeleton(10, appConstants.getWidth(0.5), 0, context),
          AddVerticalSpace(context, 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              skeleton(50, 50, 100, context),
              AddHorizontalSpace(context, 0.015),
              skeleton(50, 50, 100, context),
              AddHorizontalSpace(context, 0.015),
              skeleton(50, 50, 100, context),
            ],
          ),
        ],
      ),
    ],
  );
}
