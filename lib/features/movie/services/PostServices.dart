import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/services/MovieServices.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class PostServices {
  static Future<MoviePost?> getPostByUid(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final postsCollection = firestore.collection('posts');
      final docSnapshot = await postsCollection.doc(uid).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        // Get user by UID
        final userUid = data['user'];
        final user = await UserServices.getUserByUid(userUid);

        // Get movie by UID
        final filmUid = data['movie'];
        final movie = await MovieService().getMovieByUid(filmUid);

        if (user != null && movie != null) {
          return MoviePost(
            postId: data['postId'],
            userId: data['userId'],
            firstName: data['firstName'],
            userPhotoUrl: data['userPhotoUrl'],
            username: data['username'],
            movie: movie,
            content: data['content'] ?? '',
            likes: data['likes'] ?? 0,
            comments: data['comments'] ?? 0,
            isQuote: data["isQuote"] ?? false,
            rating: (data['rating'] ?? 0)
                .toDouble(), // ⭐️ Firestore'dan rating çekiyoruz!
            timestamp: data['timestamp'] as Timestamp,
          );
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching post by UID: $e');
      return null;
    }
  }

  /// Kullanıcının post sahibi olup olmadığını kontrol eden fonksiyon
  static Future<bool> isPostOwner(String postUid) async {
    final auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    final post = await getPostByUid(postUid);
    return post != null && post.userId == currentUser.uid;
  }
}
