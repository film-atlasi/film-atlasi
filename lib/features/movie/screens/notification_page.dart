import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/widgets/CommentPage.dart';
import 'package:film_atlasi/features/user/widgets/UserProfileRouter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId =
        FirebaseAuth.instance.currentUser?.uid; // Giriş yapan kullanıcı UID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bildirimler")),
      body: currentUserId == null
          ? const Center(child: Text("Giriş yapmalısınız"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUserId)
                  .collection("notifications")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Henüz bildiriminiz yok"));
                }

                var notifications = snapshot.data!.docs;

                return Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 20),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      var notif = notifications[index];
                      String eventType = notif["event"];
                      String fromUser = notif["from"];
                      String fromUserId = notif["fromId"];
                      String? filmId = notif["filmId"]!;
                      String? postId = notif["postId"]!;
                      String? photo = notif["photo"];

                      if (eventType == "follow") {
                        return UserProfileRouter(
                            subtitle:
                                Helpers.formatTimestamp(notif["timestamp"]),
                            userId: fromUserId,
                            trailing: Icon(
                              Icons.person,
                            ),
                            title: _getNotificationText(eventType, fromUser),
                            profilePhotoUrl: photo!);
                      } else if (eventType == "like") {
                        return UserProfileRouter(
                            subtitle:
                                Helpers.formatTimestamp(notif["timestamp"]),
                            trailing: Icon(Icons.favorite),
                            userId: fromUserId,
                            title: _getNotificationText(eventType, fromUser),
                            profilePhotoUrl: photo!);
                      } else {
                        return UserProfileRouter(
                            trailing: Icon(Icons.comment),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentPage(
                                    filmId: filmId!,
                                    postId: postId!,
                                  ),
                                ),
                              );
                            },
                            subtitle:
                                Helpers.formatTimestamp(notif["timestamp"]),
                            userId: fromUserId,
                            title: _getNotificationText(eventType, fromUser),
                            profilePhotoUrl: photo!);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  String _getNotificationText(String eventType, String username) {
    switch (eventType) {
      case "like":
        return "$username gönderini beğendi.";
      case "comment":
        return "$username gönderine yorum yaptı.";
      case "follow":
        return "$username seni takip etti.";
      default:
        return "Bilinmeyen bir bildirim.";
    }
  }
}
