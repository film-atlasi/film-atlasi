import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/user/screens/UserPage.dart';
import 'package:flutter/material.dart';

class UserProfileRouter extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String profilePhotoUrl;
  final String userId;
  final Widget? trailing;
  final Widget? extraWidget;
  final Function()? onLongPress;
  final Function()? onTap;
  final bool selected;
  final double padding;

  const UserProfileRouter({
    super.key,
    required this.userId,
    this.extraWidget,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onLongPress,
    required this.profilePhotoUrl,
    this.onTap,
    this.selected = false,
    this.padding = 0,
  });

  @override
  Widget build(BuildContext context) {
    final AppConstants appConstants = AppConstants(context);
    return ListTile(
      onLongPress: onLongPress,
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                // ignore: unrelated_type_equality_checks
                return UserPage(
                  userUid: userId,
                );
              }),
            );
          },
      title: Text(title),
      selectedTileColor: appConstants.bottomAppBarColor,
      selectedColor: appConstants.textColor,
      selected: selected,
      textColor: appConstants.textColor,
      subtitle: subtitle != null
          ? extraWidget != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    extraWidget!,
                    SizedBox(
                      height: 4,
                    ),
                    Text(subtitle!)
                  ],
                )
              : Text(subtitle!,
                  style: TextStyle(
                      color: appConstants.textLightColor, fontSize: 12))
          : null,
      contentPadding: EdgeInsets.all(padding),
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              // ignore: unrelated_type_equality_checks
              return UserPage(
                userUid: userId,
              );
            }),
          );
        },
        child: CircleAvatar(
          backgroundImage:
              // ignore: unnecessary_null_comparison
              profilePhotoUrl != null ? NetworkImage(profilePhotoUrl) : null,
          backgroundColor: appConstants.textColor,
          radius: 20,
        ),
      ),
      trailing: trailing,
    );
  }
}
