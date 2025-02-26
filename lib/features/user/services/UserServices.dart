import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/movie/models/FilmPost.dart';
import 'package:film_atlasi/features/movie/services/PostServices.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserServices {
  static Future<List<User>> searchUsers(String query) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userCollection = firestore.collection('users');

      final querySnapshot = await userCollection
          .where('userName', isGreaterThanOrEqualTo: query)
          .where('userName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      final nameQuerySnapshot = await userCollection
          .where('firstName', isGreaterThanOrEqualTo: query)
          .where('firstName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      final allDocs = querySnapshot.docs + nameQuerySnapshot.docs;

      // Remove duplicates
      final uniqueDocs = {for (var doc in allDocs) doc.id: doc}.values.toList();
      print(uniqueDocs[0].data());

      final users = uniqueDocs.map((doc) => User.fromFirestore(doc)).toList();
      return users;
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

//takip edilen kullanıcıları al
static Future<List<String>> getFollowingUserIds(String userUid) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final followingCollection = firestore.collection('following');

    // Kullanıcının takip ettiği kişileri al
    final querySnapshot = await followingCollection
        .doc(userUid)
        .collection('userFollowings')
        .get();

    // Takip edilen kullanıcıların UID'lerini bir liste olarak dönüyoruz
    return querySnapshot.docs.map((doc) => doc.id).toList();
  } catch (e) {
    print('Takip edilen kullanıcılar alınamadı: $e');
    return [];
  }
}

//takip edilen kullanıcıların postlarını al
static Future<List<MoviePost>> getFollowingUsersPosts(String userUid) async {
  try {
    final followingUserIds = await getFollowingUserIds(userUid);
    
    if (followingUserIds.isEmpty) {
      return []; // Takip edilen kimse yoksa boş liste döndür
    }

    final firestore = FirebaseFirestore.instance;
    final postsCollection = firestore.collection('posts');

    // Takip edilen kişilerin paylaştığı postları al
    final querySnapshot = await postsCollection
        .where('user', whereIn: followingUserIds) // 🔥 Takip edilenlerin postları
        .orderBy('timestamp', descending: true)
        .get();

    List<MoviePost> posts = [];
    for (var doc in querySnapshot.docs) {
      final post = await PostServices.getPostByUid(doc.id);
      if (post != null) {
        posts.add(post);
      }
    }

    return posts;
  } catch (e) {
    print('Takip edilen kullanıcıların postları alınamadı: $e');
    return [];
  }
}





  static Future<List<MoviePost>> getAllUsersPosts(String userUid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userDoc = firestore.collection('users').doc(userUid);

      final querySnapshot = await userDoc
          .collection("posts")
          .orderBy('timestamp', descending: true)
          .get();
      print(querySnapshot.docs[0].data());
      List<MoviePost> posts =
          querySnapshot.docs.map((e) => MoviePost.fromFirestore(e)).toList();
      return posts;
    } catch (e) {
      print('Error fetching user posts: $e');
      throw e;
    }
  }

  static Future<User?> getUserByUid(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final usersCollection = firestore.collection("users");
      final docSnapshot = await usersCollection.doc(uid).get();
      if (docSnapshot.exists) {
        return User.fromFirestore(docSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user by UID: $e');
      return null;
    }
  }

  static Future<String?> uploadCoverPhoto(String userUid) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Fotoğrafın kalitesini düşürerek optimize ediyoruz
        maxWidth: 1000, // Maksimum genişlik belirliyoruz
      );

      if (pickedFile == null) {
        throw Exception('Fotoğraf seçilmedi');
      }

      File file = File(pickedFile.path);
      String fileName = "cover_pictures/$userUid.jpg"; // ✅ Kapak fotoğrafı yolu

      // Firebase Storage referansı oluştur
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      // Upload metadata ekle
      SettableMetadata metadata = SettableMetadata(
          contentType: 'image/jpeg', customMetadata: {'userId': userUid});

      UploadTask uploadTask = storageRef.putFile(file, metadata);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Firestore'da kapak fotoğrafını güncelle
      await FirebaseFirestore.instance.collection('users').doc(userUid).update({
        'coverPhotoUrl':
            downloadUrl, // ✅ Firestore'a kapak fotoğrafı URL’sini kaydet
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Firebase hatası: ${e.message}');
      throw Exception('Kapak fotoğrafı yüklenemedi: ${e.message}');
    } catch (e) {
      print('Genel hata: $e');
      throw Exception('Beklenmeyen bir hata oluştu');
    }
  }

  static Future<String?> uploadProfilePhoto(String userUid) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Resim kalitesini optimize et
        maxWidth: 600, // Maksimum genişliği sınırla
      );

      if (pickedFile == null) {
        throw Exception('Fotoğraf seçilmedi');
      }

      File file = File(pickedFile.path);
      String fileName = "profile_pictures/$userUid.jpg";

      // Storage referansı oluştur
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      // Upload metadata ekle
      SettableMetadata metadata = SettableMetadata(
          contentType: 'image/jpeg', customMetadata: {'userId': userUid});

      UploadTask uploadTask = storageRef.putFile(file, metadata);

      // Upload progress takibi eklenebilir
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print('Upload progress: $progress%');
      });

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(userUid).update({
        'profilePhotoUrl': downloadUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Firebase hatası: ${e.message}');
      throw Exception('Fotoğraf yüklenemedi: ${e.message}');
    } catch (e) {
      print('Genel hata: $e');
      throw Exception('Beklenmeyen bir hata oluştu');
    }
  }

  static String? get currentUserUid {
    final user = auth.FirebaseAuth.instance.currentUser;
    return user?.uid; // Kullanıcı giriş yaptıysa UID'yi döndür, yapmadıysa null
  }
}
