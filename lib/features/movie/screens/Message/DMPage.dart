import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/app.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/models/MessageModel.dart';
import 'package:film_atlasi/features/movie/screens/Message/ChatScreen.dart';
import 'package:film_atlasi/features/movie/services/MessageServices.dart';
import 'package:film_atlasi/features/movie/widgets/Skeletons/Skeleton.dart';
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
        title: Text("Sohbetler"),
        leading: IconButton(
          onPressed: () {
            widget.pageController.animateToPage(0,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
            Provider.of<VisibilityProvider>(context, listen: false).show();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
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
              var lastMessage = MessageModel.fromMap(chat['last_message']);
              var timestamp = chat['timestamp'] as Timestamp?;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(
                      title: skeleton(10, 10, 5, context),
                      subtitle: skeleton(10, 10, 5, context),
                      leading: skeleton(30, 30, 30, context),
                    );
                  }

                  var userData = userSnapshot.data!;
                  String otherUserName =
                      userData['userName'] ?? "Bilinmeyen Kullanıcı";
                  String otherUserAvatar = userData['profilePhotoUrl'] ??
                      "https://via.placeholder.com/150";

                  return UserMessageTile(
                    otherUserAvatar: otherUserAvatar,
                    otherUserName: otherUserName,
                    lastMessage: lastMessage,
                    timestamp: timestamp,
                    otherUserId: otherUserId,
                    userId: currentUserId,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// 🔹 **Tek Bir Sohbeti Gösteren ListTile Bileşeni**
class UserMessageTile extends StatelessWidget {
  final String otherUserAvatar;
  final String otherUserName;
  final MessageModel lastMessage;
  final Timestamp? timestamp;
  final String otherUserId;
  final String userId;

  const UserMessageTile({
    super.key,
    required this.otherUserAvatar,
    required this.otherUserName,
    required this.lastMessage,
    required this.timestamp,
    required this.otherUserId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final MessageServices _messageServices = MessageServices();
    final chatId = _messageServices.generateChatId(otherUserId, userId);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(otherUserAvatar),
      ),
      title: Text(
        otherUserName,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle:
          Text(lastMessage.text, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            Helpers.formatTimestamp(timestamp!),
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.normal),
          ),
          StreamBuilder(
            stream: _messageServices.getUnreadMessagesInChat(chatId, userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }
              int unreadCount = snapshot.data as int;
              return unreadCount > 0
                  ? CircleAvatar(
                      backgroundColor: AppConstants(context).primaryColor,
                      radius: 12,
                      child: Text(
                        unreadCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : SizedBox();
            },
          )
        ],
      ),
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
