import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/services/CommentServices.dart';
import 'package:film_atlasi/features/movie/widgets/LoadingWidget.dart';
import 'package:film_atlasi/features/user/widgets/UserProfileRouter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Add this import for date formatting

class CommentPage extends StatefulWidget {
  final String postId;
  final String filmId;
  final bool isAppBar;
  const CommentPage(
      {super.key,
      required this.postId,
      required this.filmId,
      this.isAppBar = true});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final AppConstants appConstants = AppConstants(context);
    final CommentServices commentServices = CommentServices(
      filmId: widget.filmId,
      postId: widget.postId,
      context: context,
      commentController: _commentController,
      user: auth.currentUser,
    );

    return Scaffold(
      appBar: widget.isAppBar
          ? AppBar(
              title: const Text("Yorumlar"),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: commentServices.getCommentsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LoadingWidget();
                }

                var comments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    var commentData =
                        comments[index].data() as Map<String, dynamic>;
                    var timestamp = commentData["timestamp"] as Timestamp?;
                    var formattedTime = timestamp != null
                        ? Helpers.formatTimestamp(timestamp)
                        : "Zaman bilgisi yok";

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UserProfileRouter(
                        extraWidget: Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Text(
                            formattedTime,
                            style: TextStyle(
                              color: appConstants.textLightColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        userId: commentData["userId"],
                        title: commentData["userName"],
                        profilePhotoUrl: commentData["profilePhotoUrl"],
                        subtitle: commentData["content"],
                        trailing: commentData["userId"] == auth.currentUser?.uid
                            ? PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    commentServices.showEditDialog(
                                        commentData["commentId"],
                                        commentData["content"]);
                                  } else if (value == 'delete') {
                                    commentServices.deleteComment(
                                        commentData["commentId"]);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Düzenle'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Sil'),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Yorumunuzu yazın...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: commentServices.addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
