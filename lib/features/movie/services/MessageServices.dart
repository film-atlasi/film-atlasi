import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/MessageModel.dart';

class MessageServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// **📌 Sayfalı (Lazy Load) mesajları çekme**
  Future<QuerySnapshot> getMessagesPaginated(
      String chatId, int limit, DocumentSnapshot? lastMessage) async {
    Query query = _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (lastMessage != null) {
      query = query.startAfterDocument(lastMessage);
    }

    return await query.get();
  }

  /// **📌 Anlık mesajları dinleme**
  Stream<QuerySnapshot> getRealTimeMessages(String chatId) {
    return _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      String chatId = generateChatId(senderId, receiverId);

      DocumentReference chatRef = _firestore.collection('messages').doc(chatId);

      // 🔹 **MessageModel ile mesajı oluştur**
      MessageModel newMessage = MessageModel(
        id: '', // Firestore otomatik oluşturacak
        senderId: senderId,
        receiverId: receiverId,
        text: message,
        timestamp: Timestamp.now(),
        isRead: false,
      );

      // 🔹 **Mesajı Mesajlar Koleksiyonuna Ekle**
      await chatRef.collection('messages').add(newMessage.toMap());

      // 🔹 **Sohbet Bilgilerini Güncelle (Son Mesaj + Okunmamış Mesaj Sayısı)**
      await chatRef.set({
        'participants': [senderId, receiverId],
        'last_message': newMessage.toMap(),
        'unread_count':
            FieldValue.increment(1), // Okunmamış mesaj sayısını artır
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print("✅ Mesaj başarıyla gönderildi!");
    } catch (e) {
      print("❌ Mesaj gönderme hatası: $e");
    }
  }

  /// **📌 Firestore'dan mesajları çek**
  Stream<QuerySnapshot> getMessages(String senderId, String receiverId) {
    String chatId = generateChatId(senderId, receiverId);
    return _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  /// 🔹 **Tüm Sohbet Listesini Getir (Gerçek Zamanlı)**
  Stream<QuerySnapshot> getChatList(String currentUserId) {
    return _firestore
        .collection('messages')
        .where('participants', arrayContains: currentUserId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// 🔹 **Belirli Bir Sohbette Okunmamış Mesaj Sayısını Getir**
  Stream<int> getUnreadMessagesInChat(String chatId, String userId) {
    return _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .where('receiver_id', isEqualTo: userId)
        .where('is_read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// 🔹 **Tüm Sohbetlerde Kullanıcının Okunmamış Mesajlarını Getir**
  Stream<int> getTotalUnreadMessageCount(String currentUserId) {
    return _firestore
        .collection('messages')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .map((snapshot) {
      int unreadCount = 0;
      for (var doc in snapshot.docs) {
        if (doc['unread_count'] != null && doc['unread_count'] > 0) {
          unreadCount += doc['unread_count'] as int;
        }
      }
      return unreadCount;
    });
  }

  /// **📌 Kullanıcının tüm okunmamış mesajlarını okundu olarak işaretleme**
  Future<void> markAllMessagesAsRead(String chatId, String userId) async {
    try {
      var unreadMessages = await _firestore
          .collection('messages')
          .doc(chatId)
          .collection('messages')
          .where('receiver_id', isEqualTo: userId)
          .where('is_read', isEqualTo: false)
          .get();

      for (var doc in unreadMessages.docs) {
        doc.reference.update({'is_read': true});
      }
    } catch (e) {
      print("Tüm mesajları okundu olarak işaretleme hatası: $e");
    }
  }

  /// 🔹 **Kullanıcının kaç farklı sohbetten okunmamış mesajı olduğunu getir**
  Stream<int> getUnreadChatsCount(String currentUserId) {
    return _firestore
        .collection('messages')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .map((snapshot) {
      int unreadChatsCount = 0;
      for (var doc in snapshot.docs) {
        if (doc['unread_count'] != null && doc['unread_count'] > 0) {
          unreadChatsCount++;
        }
      }
      return unreadChatsCount;
    });
  }

  Future<void> markMessageAsRead(String messageId, String chatId) async {
    await _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'is_read': true});

    print("✅ Mesaj okundu olarak işaretlendi!");
  }

  /// 🔹 **Sohbet ID'sini oluştur**
  String generateChatId(String userId1, String userId2) {
    return userId1.hashCode >= userId2.hashCode
        ? "${userId1}_$userId2"
        : "${userId2}_$userId1";
  }
}
