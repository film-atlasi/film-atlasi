import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/movie/screens/Message/MesajBalonu.dart';
import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:film_atlasi/features/movie/widgets/FilmBilgiWidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:film_atlasi/features/movie/services/MessageServices.dart';

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
  final ScrollController _scrollController =
      ScrollController(); // Otomatik kaydırma için
  final MessageServices _messageServices =
      MessageServices(); // Firestore servisimiz
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var lastSender = '';
  bool isTyping = false;
  Movie? selectedFilm;

  void setTyping() {
    setState(() {
      if (_messageController.text.isNotEmpty) {
        isTyping = true;
      } else {
        isTyping = false;
      }
    });
  }

  Future<void> _filmAraVeSec() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FilmAraWidget(
                mode: "message_send",
              )),
    );

    if (result != null) {
      setState(() {
        selectedFilm = result; // Seçilen filmi kaydet
      }); // Seçilen filmi gönder
    }
  }

  void setSelectedFilmEmpty() {
    setState(() {
      selectedFilm = null;
    });
  }

  String get currentUserId => _auth.currentUser!.uid;
  String get chatId =>
      _messageServices.generateChatId(currentUserId, widget.receiverId);

  @override
  void initState() {
    super.initState();
    // 🔹 Sayfa açıldığında en aşağı kaydır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    _listenForNewMessages();
  }

  /// **📌 Yeni mesajları takip edip "görüldü" olarak işaretle**
  void _listenForNewMessages() {
    _messageServices
        .getMessages(currentUserId, widget.receiverId)
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _messageServices.markAllMessagesAsRead(chatId, currentUserId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppConstants _appConstants = AppConstants(context);
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
          // **MESAJ AKIŞI**
          Expanded(child: _buildMessageList(_appConstants)),

          // **MESAJ GİRİŞ ALANI**
          _buildMessageInput(_appConstants),
        ],
      ),
    );
  }

  /// **📌 Firestore'dan mesajları çekme (`MessageServices` kullanarak)**
  Widget _buildMessageList(AppConstants appConstants) {
    return StreamBuilder<QuerySnapshot>(
      stream: _messageServices.getMessages(currentUserId, widget.receiverId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Henüz mesaj yok"));
        }

        List<DocumentSnapshot> messages = snapshot.data!.docs;

        // 🔹 Mesajlar yüklendiğinde en aşağı kaydır
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        return GroupedListView<DocumentSnapshot, String>(
          controller: _scrollController,
          elements: messages,
          floatingHeader: true,
          groupBy: (message) {
            Timestamp? timestamp = message['timestamp'] as Timestamp?;
            DateTime date =
                timestamp != null ? timestamp.toDate() : DateTime.now();
            return DateFormat('dd MMM yyyy').format(date);
          },
          groupSeparatorBuilder: (String date) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                date,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          itemBuilder: (context, DocumentSnapshot message) {
            final header = lastSender != message['sender_id'];
            lastSender = message['sender_id'];
            return MesajBalonu(
              message: message,
              currentUserId: currentUserId,
              isHeader: header,
            );
          },
          order: GroupedListOrder
              .ASC, // 🔥 Eski mesajlar yukarıda, yeni mesajlar aşağıda
        );
      },
    );
  }

  /// **📌 Kullanıcıdan mesaj girişini almak için UI**
  Widget _buildMessageInput(AppConstants appConstants) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: selectedFilm != null
                ? FilmBilgiWidget(movieId: selectedFilm!.id)
                : TextField(
                    controller: _messageController,
                    onChanged: (value) {
                      setTyping();
                    },
                    decoration: const InputDecoration(
                      hintText: "Mesaj yaz...",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: selectedFilm != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: setSelectedFilmEmpty,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: appConstants.primaryColor.withOpacity(0.8),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.arrow_upward,
                                color: appConstants.iconColor),
                            onPressed: _sendMovie,
                          )),
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appConstants.primaryColor.withOpacity(0.8),
                    ),
                    child: !isTyping
                        ? IconButton(
                            icon: Icon(Icons.movie,
                                color: appConstants.iconColor),
                            onPressed: _filmAraVeSec,
                          )
                        : IconButton(
                            icon: Icon(Icons.arrow_upward,
                                color: appConstants.iconColor),
                            onPressed: _sendMessage,
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  /// **📌 Mesaj gönderme işlemi (MessageServices ile)**
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String messageText = _messageController.text.trim();
    _messageController.clear();
    await _messageServices.sendMessage(
        senderId: currentUserId,
        receiverId: widget.receiverId,
        message: messageText,
        isMovie: false);

    _scrollToBottom(); // **Mesaj gönderildiğinde en alttaki mesaja kaydır**
  }

  Future<void> _sendMovie() async {
    if (selectedFilm == null) return;

    await _messageServices.sendMessage(
        senderId: currentUserId,
        receiverId: widget.receiverId,
        message: selectedFilm!.id,
        isMovie: true);

    setSelectedFilmEmpty();
    _scrollToBottom(); // **Mesaj gönderildiğinde en alttaki mesaja kaydır**
  }

  /// **📌 Yeni mesaj gönderildiğinde en alta kaydır**
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
