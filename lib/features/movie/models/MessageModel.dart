import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageModel {
  final String? id; // Firestore'daki döküman ID'si
  final String senderId;
  final String receiverId;
  final String text;
  final Timestamp timestamp;
  final bool isRead;
  bool fromOtherUser;
  final String? currentUser = FirebaseAuth.instance.currentUser!.uid;
  final bool isMovie;

  MessageModel(
      {this.id,
      required this.senderId,
      required this.receiverId,
      required this.text,
      required this.timestamp,
      required this.isRead,
      this.fromOtherUser = false,
      this.isMovie = false}) {
    fromOtherUser = senderId != currentUser;
  }

  /// 🔹 **Firestore'dan Veri Çevirme (`fromFirestore`)**
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return MessageModel(
      id: doc.id, // Firestore doküman ID'si
      senderId: data?['sender_id'] ?? '',
      receiverId: data?['receiver_id'] ?? '',
      text: data?['text'] ?? '',
      timestamp: data?['timestamp'] ?? Timestamp.now(),
      isRead: data?['is_read'] ?? false,
      isMovie: data?['is_movie'] ?? false,
    );
  }

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      senderId: data['sender_id'] ?? '',
      receiverId: data['receiver_id'] ?? '',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      isRead: data['is_read'] ?? false,
      isMovie: data['is_movie'] ?? false,
    );
  }

  /// 🔹 **Firestore'a Kaydetmek İçin (`toMap`)**
  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'text': text,
      'timestamp': timestamp,
      'is_read': isRead,
      'is_movie': isMovie,
    };
  }
}
