import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/widgets/Skeletons/FilmBilgiSkeleton.dart';
import 'package:film_atlasi/features/movie/widgets/Skeletons/Skeleton.dart';
import 'package:flutter/material.dart';

class MoviePostSkeleton extends StatelessWidget {
  const MoviePostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppConstants appConstants = AppConstants(context);

    return Card(
      color: appConstants.dialogColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserPageRouterSkeleton(appConstants: appConstants),
            AddVerticalSpace(context, 0.02),
            skeleton(15, 150, 20, appConstants.textLightColor,
                appConstants.textColor),
            AddVerticalSpace(context, 0.015),
            skeleton(10, 150, 20, appConstants.textLightColor,
                appConstants.textColor),
            AddVerticalSpace(context, 0.015),
            FilmBilgiSkeleton(appConstants, context),
            AddVerticalSpace(context, 0.015),
            postActionsSkeleton(appConstants, context),
            AddVerticalSpace(context, 0.02),
            skeleton(10, 100, 20, appConstants.textLightColor,
                appConstants.textColor),
          ],
        ),
      ),
    );
  }
}

Widget postActionsSkeleton(AppConstants appConstants, BuildContext context) {
  return SizedBox(
    width: appConstants.getWidth(1),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            skeleton(30, 30, 20, appConstants.textLightColor,
                appConstants.textColor),
            AddHorizontalSpace(context, 0.05),
            skeleton(30, 30, 20, appConstants.textLightColor,
                appConstants.textColor),
          ],
        ),
        skeleton(
            30, 30, 20, appConstants.textLightColor, appConstants.textColor),
      ],
    ),
  );
}

class AlintiSkeleton extends StatelessWidget {
  const AlintiSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppConstants appConstants = AppConstants(context);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        color: appConstants.dialogColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserPageRouterSkeleton(
                appConstants: appConstants,
              ),
              AddVerticalSpace(context, 0.025),
              skeleton(15, appConstants.getWidth(0.4), 20,
                  appConstants.textLightColor, appConstants.textColor),
              AddVerticalSpace(context, 0.01),
              skeleton(10, appConstants.getWidth(0.2), 20,
                  appConstants.textLightColor, appConstants.textColor),
              AddVerticalSpace(context, 0.02),
              postActionsSkeleton(appConstants, context),
              AddVerticalSpace(context, 0.02),
              skeleton(10, 100, 20, appConstants.textLightColor,
                  appConstants.textColor),
            ],
          ),
        ),
      ),
    );
  }
}

class UserPageRouterSkeleton extends StatelessWidget {
  const UserPageRouterSkeleton({
    super.key,
    required this.appConstants,
  });

  final AppConstants appConstants;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        skeleton(
          40,
          40,
          50,
          appConstants.textLightColor,
          appConstants.textColor,
        ),
        AddHorizontalSpace(context, 0.01),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            skeleton(15, appConstants.getWidth(0.4), 10,
                appConstants.textLightColor, appConstants.textColor),
            AddVerticalSpace(context, 0.005),
            skeleton(10, appConstants.getWidth(0.2), 10,
                appConstants.textLightColor, appConstants.textColor),
          ],
        )
      ],
    );
  }
}
