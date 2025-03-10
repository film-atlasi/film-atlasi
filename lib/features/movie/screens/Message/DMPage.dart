import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/app.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/screens/Message/ChatScreen.dart';
import 'package:film_atlasi/features/movie/services/MessageServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DirectMessagePage extends StatefulWidget {
  final PageController pageController;
  const DirectMessagePage({super.key, required this.pageController});

  @override
  State<DirectMessagePage> createState() => _DirectMessagePageState();
}

class _DirectMessagePageState extends State<DirectMessagePage> {
  final MessageServices _messageServices = MessageServices();
  final User? user = FirebaseAuth.instance.currentUser;
  late String currentUserId = user!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );

            Provider.of<VisibilityProvider>(context, listen: false)
                .toggleVisibility();
          },
        ),
        title: Text("Sohbetler"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _messageServices.getChatList(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Henüz sohbet yok"));
          }

          var chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index];
              var participants = List<String>.from(chat['participants']);
              var otherUserId =
                  participants.firstWhere((id) => id != currentUserId);
              var lastMessage = chat['last_message'];
              var timestamp = chat['timestamp'] as Timestamp?;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(title: Text("Yükleniyor..."));
                  }

                  var userData = userSnapshot.data!;
                  String otherUserName =
                      userData['userName'] ?? "Bilinmeyen Kullanıcı";
                  String otherUserAvatar = userData['profilePhotoUrl'];

                  return UserMessageTile(
                      otherUserAvatar: otherUserAvatar,
                      otherUserName: otherUserName,
                      lastMessage: lastMessage,
                      timestamp: timestamp,
                      otherUserId: otherUserId);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UserMessageTile extends StatelessWidget {
  const UserMessageTile({
    super.key,
    required this.otherUserAvatar,
    required this.otherUserName,
    required this.lastMessage,
    required this.timestamp,
    required this.otherUserId,
  });

  final String otherUserAvatar;
  final String otherUserName;
  final dynamic lastMessage;
  final Timestamp? timestamp;
  final String otherUserId;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(otherUserAvatar),
      ),
      title: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(otherUserName),
            timestamp != null
                ? Text(Helpers.formatTimestamp(timestamp!),
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 12))
                : SizedBox.shrink(),
          ],
        ),
      ),
      subtitle: Text(lastMessage),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiverId: otherUserId,
              receiverName: otherUserName,
              receiverAvatar: otherUserAvatar,
            ),
          ),
        );
      },
    );
  }
}
