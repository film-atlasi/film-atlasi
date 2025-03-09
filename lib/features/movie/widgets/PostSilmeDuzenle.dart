import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:flutter/material.dart';

class PostSilmeDuzenleme extends StatefulWidget {
  final MoviePost moviePost;
  final String filmId; // 🔥 Filmin ID'sini de aldık

  const PostSilmeDuzenleme({
    super.key,
    required this.moviePost,
    required this.filmId, // 🔥 Film ID zorunlu hale geldi
  });

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
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          _editPost();
        } else if (value == 'delete') {
          _deletePost();
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Text('Düzenle'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Sil'),
        ),
      ],
    );
  }

  /// **🔥 Postu Silme İşlemi**
  void _deletePost() async {
    bool confirmDelete = await _showConfirmationDialog();
    if (confirmDelete) {
      try {
        // **🔥 Doğru koleksiyon yolu kullanıldı**
        await FirebaseFirestore.instance
            .collectionGroup('posts')
            .where('postId', isEqualTo: widget.moviePost.postId)
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gönderi silindi!")),
        );

        // **🔥 Silinen postu hemen UI'dan kaldır**
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        print("❌ Silme hatası: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gönderi silinirken bir hata oluştu! $e")),
        );
      }
    }
  }

  /// **🔥 Postu Düzenleme İşlemi**
  void _editPost() async {
    String? updatedContent = await _showEditDialog();
    if (updatedContent != null && updatedContent.trim().isNotEmpty) {
      try {
        // **🔥 Doğru koleksiyon yolu kullanıldı**
        await FirebaseFirestore.instance
            .collectionGroup("posts")
            .where('postId', isEqualTo: widget.moviePost.postId)
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.update({'content': updatedContent});
          }
        });

        if (mounted) {
          setState(() {
            widget.moviePost.content = updatedContent;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gönderi güncellendi!")),
        );
      } catch (e) {
        print("❌ Güncelleme hatası: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Gönderi güncellenirken bir hata oluştu!")),
        );
      }
    }
  }

  /// **🗑️ Silme Onayı Penceresi**
  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Gönderiyi Sil"),
            content:
                const Text("Bu gönderiyi silmek istediğinize emin misiniz?"),
            actions: [
              TextButton(
                child: const Text("İptal"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text("Sil", style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// **📝 Düzenleme Penceresi**
  Future<String?> _showEditDialog() async {
    _contentController.text = widget.moviePost.content;
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Gönderiyi Düzenle"),
          content: TextField(
            controller: _contentController,
            maxLines: 4,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              child: const Text("İptal"),
              onPressed: () => Navigator.pop(context, null),
            ),
            TextButton(
              child: const Text("Kaydet"),
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
