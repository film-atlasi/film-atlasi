import 'package:cloud_firestore/cloud_firestore.dart';

class MessageServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    required String senderName,
    required String receiverName,
    required String senderAvatar,
    required String receiverAvatar,
  }) async {
    try {
      // Sohbet ID'sini oluştur (Kullanıcı ID'lerini sıralayarak)
      String chatId = senderId.hashCode <= receiverId.hashCode
          ? "${senderId}_$receiverId"
          : "${receiverId}_$senderId";

      // Firestore referansı
      DocumentReference chatRef =
          FirebaseFirestore.instance.collection('messages').doc(chatId);

      // Mesaj koleksiyonuna yeni mesaj ekle
      await chatRef.collection('messages').add({
        'sender_id': senderId,
        'receiver_id': receiverId,
        'text': message,
        'timestamp': FieldValue.serverTimestamp(),
        'is_read': false, // Mesaj ilk başta okunmamış olacak
      });

      // Sohbet bilgilerini güncelle (Son mesaj için)
      await chatRef.set({
        'participants': [senderId, receiverId],
        'participants_name': [senderName, receiverName],
        'participants_avatar': [senderAvatar, receiverAvatar],
        'last_message': message,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print("Mesaj başarıyla gönderildi!");
    } catch (e) {
      print("Mesaj gönderme hatası: $e");
    }
  }

  Stream<QuerySnapshot> getMessages(String senderId, String receiverId) {
    String chatId = senderId.hashCode <= receiverId.hashCode
        ? "${senderId}_$receiverId"
        : "${receiverId}_$senderId";

    return FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> markMessagesAsRead(String chatId, String userId) async {
    var messages = await FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .where('receiver_id', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .get();

    for (var doc in messages.docs) {
      doc.reference.update({'is_read': true});
    }
  }

  Stream<QuerySnapshot> getChatList(String currentUserId) {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('participants', arrayContains: currentUserId)
        .orderBy('timestamp', descending: true) // En son mesajı en üstte göster
        .snapshots();
  }
}
