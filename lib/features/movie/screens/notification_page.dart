import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/screens/PostDetailPage.dart';
import 'package:film_atlasi/features/movie/widgets/CommentPage.dart';
import 'package:film_atlasi/features/user/screens/UserPage.dart';
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

  //bildirim ikonları
  Widget _getNotificationIcon(String eventType) {
    switch (eventType) {
      case "like":
        return const Icon(Icons.favorite, color: Colors.red);
      case "comment":
        return const Icon(Icons.comment, color: Color.fromARGB(255, 255, 255, 255));
      case "follow":
        return const Icon(Icons.person_add, color: Color.fromARGB(255, 64, 55, 146));
      default:
        return const Icon(Icons.notifications, color: Colors.grey);
    }
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

                      return UserProfileRouter(
                        subtitle: Helpers.formatTimestamp(notif["timestamp"]),
                        userId: fromUserId,
                        trailing: _getNotificationIcon(
                            eventType), // 🔹 Event tipine göre ikon
                        title: _getNotificationText(eventType, fromUser),
                        profilePhotoUrl: photo!,
                        onTap: () {
                          if (eventType == "follow") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserPage(
                                  userUid: fromUserId,
                                ),
                              ),
                            );
                          } else if (eventType == "like" ||
                              eventType == "comment") {
                            // Eğer postId veya filmId null ise fonksiyondan çık
                            if (postId == null ||
                                postId.isEmpty ||
                                filmId == null ||
                                filmId.isEmpty) {
                              print("❌ Hata: Post veya Film ID eksik!");
                              return null;
                            }
                            // 🔹 Post sayfasına git
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailPage(
                                    postId: postId, filmId: filmId),
                              ),
                            );
                          }
                        },
                      );
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
