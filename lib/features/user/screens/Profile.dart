import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/core/utils/helpers.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Map<String, dynamic>? userData; // Firestore'dan gelen kullanıcı verisi
  bool isLoading = true; // Veriler yüklenirken gösterilecek durum

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _fetchUserData(); // Kullanıcı verilerini çek
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      // Giriş yapan kullanıcının UID'sini al
      final auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final uid = currentUser.uid;

        // Firestore'dan kullanıcı bilgilerini çek
        final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('users') // Kullanıcı bilgileri koleksiyonu
            .doc(uid) // Kullanıcı UID'sine göre dökümanı çek
            .get();

        if (snapshot.exists) {
          setState(() {
            userData = snapshot.data();
            isLoading = false;
          });
        } else {
          print("Kullanıcı verisi bulunamadı.");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("Kullanıcı giriş yapmamış.");
      }
    } catch (e) {
      print("Kullanıcı verisi çekilirken hata oluştu: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Yükleniyor animasyonu
          : userData == null
              ? const Center(child: Text("Kullanıcı bilgileri bulunamadı."))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kapak Fotoğrafı
                      Container(
                        height: MediaQuery.of(context).size.height * 0.18,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.grey, // Kapak fotoğrafı için yer tutucu
                        ),
                      ),
                      // Profil Fotoğrafı
                      Transform.translate(
                        offset: const Offset(20, -50),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: userData!['profilePhotoUrl'] != null
                              ? NetworkImage(userData!['profilePhotoUrl'])
                              : null,
                          child: userData!['profilePhotoUrl'] == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${userData!['firstName']} ",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "@${userData!['userName']}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Meslek: ${userData!['job'] ?? 'Bilinmiyor'}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "yaş: ${userData!['age'] ?? 'Bilinmiyor'}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Profil Ekranı'),
    );
  }
}
