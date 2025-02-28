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
      print("object");
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
        "timestamp": FieldValue.serverTimestamp(), // Zaman damgası
      });
      print("✅ Bildirim başarıyla eklendi: $eventType");
    } catch (e) {
      print("🚨 Bildirim ekleme hatası: $e");
    }
  }
}
