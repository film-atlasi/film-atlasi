import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostSilmeDuzenleme extends StatefulWidget {
  final MoviePost moviePost;

  const PostSilmeDuzenleme({
    Key? key,
    required this.moviePost,
  }) : super(key: key);

  @override
  _PostSilmeDuzenlemeState createState() => _PostSilmeDuzenlemeState();
}

class _PostSilmeDuzenlemeState extends State<PostSilmeDuzenleme> {
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.moviePost.content);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _editPost();
            } else if (value == 'delete') {
              _deletePost();
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 'edit',
              child: Text('Düzenle'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Sil'),
            ),
          ],
        ),
      ],
    );
  }

  void _deletePost() async {
    bool confirmDelete = await _showConfirmationDialog();
    if (confirmDelete) {
      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.moviePost.postId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gönderi silindi!")),
        );

        setState(() {});
      } catch (e) {
        print("Silme hatası: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gönderi silinirken bir hata oluştu!")),
        );
      }
    }
  }

  void _editPost() async {
    String? updatedContent = await _showEditDialog();
    if (updatedContent != null && updatedContent.trim().isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.moviePost.postId)
            .update({"content": updatedContent});

        setState(() {
          widget.moviePost.content = updatedContent;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gönderi güncellendi!")),
        );
      } catch (e) {
        print("Güncelleme hatası: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gönderi güncellenirken bir hata oluştu!")),
        );
      }
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Gönderiyi Sil"),
            content: Text("Bu gönderiyi silmek istediğinize emin misiniz?"),
            actions: [
              TextButton(
                child: Text("İptal"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text("Sil"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<String?> _showEditDialog() async {
    _contentController.text = widget.moviePost.content;
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Gönderiyi Düzenle"),
          content: TextField(
            controller: _contentController,
            maxLines: 4,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () => Navigator.pop(context, null),
            ),
            TextButton(
              child: Text("Kaydet"),
              onPressed: () {
                Navigator.pop(context, _contentController.text);
              },
            ),
          ],
        );
      },
    );
  }
}
