import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/services/notification_service..dart';
import 'package:film_atlasi/features/user/models/User.dart';

class FollowServices {
  Future<void> followUser(String currentUserId, String targetUserId,
      String currentUsername, String photo) async {
    ///Bu fonksiyon currentUser'in following_count unu artırır.
    ///Bu fonksiyon targetUser'in followers_count unu artırır.
    ///Bu fonksiyon following collection'unda currentUserId li dökmana targetUserId yi ekler.
    ///Bu fonksiyon followers collection'unda targetUserId li dökümana currentUserId yi ekler.
    ///

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      ///
      ///TargetUser in followers listesine currentUser'i ekleme
      ///
      await firestore.collection('followers').doc(targetUserId).set({
        'followers': FieldValue.arrayUnion([currentUserId])
      }, SetOptions(merge: true));

      ///
      ///CurrentUser'in following listesine targetUser'i ekleyelim
      ///
      await firestore.collection('following').doc(currentUserId).set({
        'following': FieldValue.arrayUnion([targetUserId])
      }, SetOptions(merge: true));

      ///
      ///akip edilen kişinin takipçi sayısını 1 artır
      ///
      await firestore.collection('users').doc(targetUserId).update({
        'followers': FieldValue.increment(1),
      });

      ///
      ///üncel kullanıcının takip ettiği kişi sayısını 1 artır
      ///
      await firestore.collection('users').doc(currentUserId).update({
        'following': FieldValue.increment(1),
      });

      await NotificationService().addNotification(
          toUserId: targetUserId,
          fromUserId: currentUserId,
          fromUsername: currentUsername,
          photo: photo,
          eventType: "follow");
    } catch (e) {
      print("Hata oluştu takip ederken $e");
    }
  }

  Future<List<User>> getFollowings(String currentUserId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot doc =
          await firestore.collection('following').doc(currentUserId).get();

      if (doc.exists) {
        List<String> followingIds = List<String>.from(doc['following']);
        List<User> followingUsers = [];

        for (String userId in followingIds) {
          DocumentSnapshot userDoc =
              await firestore.collection('users').doc(userId).get();
          if (userDoc.exists) {
            followingUsers.add(User.fromFirestore(userDoc));
          }
        }
        return followingUsers;
      }
      return [];
    } catch (e) {
      print("Hata oluştu takip edilenleri alırken $e");
      return [];
    }
  }

  Future<List<User>> getFollowers(String targetUserId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot doc =
          await firestore.collection('followers').doc(targetUserId).get();

      if (doc.exists) {
        List<String> followerIds = List<String>.from(doc['followers']);
        List<User> followerUsers = [];

        for (String userId in followerIds) {
          DocumentSnapshot userDoc =
              await firestore.collection('users').doc(userId).get();
          if (userDoc.exists) {
            followerUsers.add(User.fromFirestore(userDoc));
          }
        }
        return followerUsers;
      }
      return [];
    } catch (e) {
      print("Hata oluştu takipçileri alırken $e");
      return [];
    }
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      ///
      ///TargetUser'in followers listesinden currentUser'i çıkarma
      ///
      await firestore.collection('followers').doc(targetUserId).update({
        'followers': FieldValue.arrayRemove([currentUserId])
      });

      ///
      ///CurrentUser'in following listesinden targetUser'i çıkarma
      ///
      await firestore.collection('following').doc(currentUserId).update({
        'following': FieldValue.arrayRemove([targetUserId])
      });

      ///
      ///Takip edilen kişinin takipçi sayısını 1 azalt
      ///
      await firestore.collection('users').doc(targetUserId).update({
        'followers': FieldValue.increment(-1),
      });

      ///
      ///Güncel kullanıcının takip ettiği kişi sayısını 1 azalt
      ///
      await firestore.collection('users').doc(currentUserId).update({
        'following': FieldValue.increment(-1),
      });
    } catch (e) {
      print("Hata oluştu takipten çıkarırken $e");
    }
  }

  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    //mevcut kullanıcıların tüm takip ettikleri
    try {
      DocumentSnapshot doc =
          await firestore.collection('following').doc(currentUserId).get();

      if (doc.exists) {
        List<String> followingList = List<String>.from(doc['following']);
        return followingList.contains(targetUserId);
      }
    } on Exception catch (e) {
      // TODO
    }
    return false;
  }

  Stream<bool> isFollowingStream(String currentUserId, String targetUserId) {
    return FirebaseFirestore.instance
        .collection('following')
        .doc(currentUserId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        List<String> followingList = List<String>.from(doc['following']);
        return followingList.contains(targetUserId);
      }
      return false;
    });
  }
}
