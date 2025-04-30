import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/movie/widgets/FilmBilgiWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MesajBalonu extends StatelessWidget {
  final DocumentSnapshot message;
  final String currentUserId;
  final bool isHeader;

  const MesajBalonu({
    super.key,
    required this.message,
    required this.currentUserId,
    required this.isHeader,
  });

  @override
  Widget build(BuildContext context) {
    bool isMe = message['sender_id'] == currentUserId;
    final AppConstants _appConstants = AppConstants(context);
    String messageText = message['text'];
    bool isMovie = message["is_movie"];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMovie
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width *
                  0.7, // 🔥 Maksimum genişlik %70
        ),
        child: IntrinsicWidth(
          // 🔥 İçeriğe göre genişliği belirler (kısa mesajlar dar olacak)
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: isMe ? null : Colors.grey[200],
              gradient: isMe
                  ? AppConstants.linearGradiant
                  : null,
              borderRadius: isMe
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topLeft: Radius.circular(12),
                      topRight: isHeader ? Radius.zero : Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      topLeft: isHeader ? Radius.zero : Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 **Mesaj İçeriği**
                isMovie
                    ? FilmBilgiWidget(
                        movieId: messageText,
                        titleColor: isMe ? Colors.white : Colors.black,
                      )
                    : Text(
                        messageText,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                const SizedBox(height: 4),

                // 🔹 **Saat Bilgisi**
                saatVeOkundu(isMe),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row saatVeOkundu(bool isMe) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: isMe ? Alignment.bottomLeft : Alignment.bottomRight,
          child: Text(
            "${DateFormat('HH:mm').format(
              (message['timestamp'] as Timestamp).toDate(),
            )} • ",
            style: TextStyle(
              color: isMe ? Colors.white70 : Colors.black54,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        isMe
            ? Align(
                alignment: Alignment.bottomRight,
                child: message['is_read']
                    ? Icon(
                        Icons.done_all,
                        size: 16,
                      )
                    : Icon(
                        Icons.done,
                        size: 16,
                      ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
