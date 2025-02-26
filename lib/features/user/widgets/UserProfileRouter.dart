import 'package:film_atlasi/features/user/screens/Profile.dart';
import 'package:film_atlasi/features/user/screens/UserPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileRouter extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String profilePhotoUrl;
  final String userId;
  final Widget? trailing;

  const UserProfileRouter(
      {super.key,
      required this.userId,
      required this.title,
      this.subtitle,
      this.trailing,
      required this.profilePhotoUrl});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            // ignore: unrelated_type_equality_checks
            if (userId == currentUserId) {
              return ProfileScreen();
            }

            return UserPage(
              userUid: userId,
            );
          }),
        );
      },
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(
        // ignore: unnecessary_null_comparison
        backgroundImage:
            // ignore: unnecessary_null_comparison
            profilePhotoUrl != null ? NetworkImage(profilePhotoUrl) : null,
        backgroundColor: Colors.white,
        radius: 20,
      ),
      trailing: trailing,
    );
  }
}
