import 'package:film_atlasi/features/movie/screens/notification_page.dart';
import 'package:film_atlasi/features/movie/services/notification_service..dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationService notificationService = NotificationService();
    final User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<int>(
      stream: notificationService.getUnreadNotificationCount(user!.uid),
      builder: (context, snapshot) {
        bool hasNew = snapshot.data != null && snapshot.data! > 0;
        return Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: hasNew ? Colors.red : Colors.white,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              ),
            ),
            if (hasNew)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    snapshot.data! > 9 ? "9+" : snapshot.data.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
