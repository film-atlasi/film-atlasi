import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> toggleLike(String postId, String filmId) async {
  String? userId = _auth.currentUser?.uid;
  if (userId == null) return;

  DocumentReference postRef = _firestore.collection('posts').doc(postId);
  DocumentReference likedRef =
      _firestore.collection("users").doc(userId).collection("begenilenler").doc(postId);

  DocumentSnapshot likedSnapshot = await likedRef.get();
  DocumentSnapshot postSnapshot = await postRef.get();

  if (likedSnapshot.exists) {
    print("🚨 Beğeni kaldırılıyor: $postId");
    await likedRef.delete();
    await postRef.update({
      "likes": (postSnapshot["likes"] ?? 0) - 1,
      "likedUsers": FieldValue.arrayRemove([userId])
    });
  } else {
    print("✅ Yeni beğeni ekleniyor: $postId");
    await likedRef.set({
      "postId": postId,
      "filmId": filmId,
      "timestamp": FieldValue.serverTimestamp()
    });

    await postRef.update({
      "likes": (postSnapshot["likes"] ?? 0) + 1,
      "likedUsers": FieldValue.arrayUnion([userId])
    });
  }
}

}
