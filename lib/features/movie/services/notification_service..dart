import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNotification(
      {required String toUserId,
      required String fromUserId,
      required String fromUsername,
      required String eventType,
      String? filmId = "", // Post ID opsiyonel (Takip için gerekmez)
      String? postId = "",
      String? photo = ""}) async {
    try {

      if(toUserId == fromUserId) return;

      await _firestore
          .collection("users")
          .doc(toUserId) // Kullanıcının UID’si (Bildirim alacak kişi)
          .collection("notifications")
          .add({
        "fromId": fromUserId, // Kimden geldi
        "from": fromUsername, // Kimden geldi (Kullanıcı adı)
        "event": eventType, // Bildirim türü (like, follow, comment)
        "filmId": filmId, // Posta bağlı bildirimler için
        "postId": postId,
        "photo": photo,
        "read": false, // Okundu mu?
        "timestamp": FieldValue.serverTimestamp(), // Zaman damgası
      });
      print("✅ Bildirim başarıyla eklendi: $eventType");
    } catch (e) {
      print("🚨 Bildirim ekleme hatası: $e");
    }
  }

  Future<void> markNotificationRead(
      String userId, String notificationId) async {
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("notifications")
          .doc(notificationId)
          .update({"read": true});
      print("✅ Bildirim okundu olarak işaretlendi");
    } catch (e) {
      print("🚨 Bildirim okundu olarak işaretlenemedi: $e");
    }
  }

  Stream<bool> hasNewNotifications(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .where("read", isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  Stream<int> getUnreadNotificationCount(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .where("read", isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> deleteNotification(String userId, String notificationId) async {
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("notifications")
          .doc(notificationId)
          .delete();
      print("✅ Bildirim silindi");
    } catch (e) {
      print("🚨 Bildirim silinemedi: $e");
    }
  }
}
