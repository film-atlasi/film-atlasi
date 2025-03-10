import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart'; // Tarih formatlamak için

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverAvatar;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverAvatar,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get currentUserId => _auth.currentUser!.uid; // Giriş yapan kullanıcının UID’si

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.receiverAvatar),
            ),
            const SizedBox(width: 10),
            Text(widget.receiverName),
          ],
        ),
      ),
      body: Column(
        children: [
          // 🔹 GERÇEK ZAMANLI MESAJ AKIŞI
          Expanded(child: _buildMessageList()),

          // 🔹 MESAJ GİRİŞ ALANI
          _buildMessageInput(),
        ],
      ),
    );
  }

  /// 🔹 Firestore'dan gerçek zamanlı mesajları çekme
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getMessageStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Henüz mesaj yok"));
        }

        List<DocumentSnapshot> messages = snapshot.data!.docs;

        return GroupedListView<DocumentSnapshot, String>(
          elements: messages,
          groupBy: (message) {
            DateTime date = (message['timestamp'] as Timestamp).toDate();
            return DateFormat('dd MMM yyyy').format(date); // Gruplama tarihi
          },
          groupSeparatorBuilder: (String date) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                date,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          itemBuilder: (context, DocumentSnapshot message) {
            bool isMe = message['sender_id'] == currentUserId;

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message['text'],
                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                ),
              ),
            );
          },
          order: GroupedListOrder.DESC, // En yeni mesaj en altta olacak
        );
      },
    );
  }

  /// 🔹 Firestore'dan gerçek zamanlı mesaj akışı
  Stream<QuerySnapshot> _getMessageStream() {
    String chatId = _generateChatId(currentUserId, widget.receiverId);

    return _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// 🔹 Mesaj gönderme fonksiyonu
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String chatId = _generateChatId(currentUserId, widget.receiverId);
    String messageText = _messageController.text.trim();

    await _firestore.collection('messages').doc(chatId).collection('messages').add({
      'sender_id': currentUserId,
      'receiver_id': widget.receiverId,
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Son mesaj bilgisi güncelle
    await _firestore.collection('messages').doc(chatId).set({
      'participants': [currentUserId, widget.receiverId],
      'last_message': messageText,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    _messageController.clear();
  }

  /// 🔹 Kullanıcıdan mesaj girişini almak için UI
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Mesaj yaz...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  /// 🔹 Chat ID oluşturma (Kullanıcı UID'lerine göre)
  String _generateChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? "${userId1}_$userId2"
        : "${userId2}_$userId1";
  }
}
