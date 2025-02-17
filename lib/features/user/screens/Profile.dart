import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:film_atlasi/features/user/widgets/FilmKutusu.dart';
import 'package:film_atlasi/features/user/widgets/FilmListProfile.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  late String userUid;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this); // TabController length = 3
    _fetchUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      final auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        setState(() {
          userUid = currentUser.uid;
          userData = snapshot.exists ? snapshot.data() : null;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Kullanıcı verisi çekilirken hata oluştu: $e");
      setState(() => isLoading = false);
    }
  }

  Stream<QuerySnapshot> getUserPosts() {
    final user = auth.FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('posts')
        .where('user', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text("Kullanıcı bilgileri bulunamadı."))
              : _buildProfileScreenContent(),
    );
  }

  Widget _buildProfileScreenContent() {
    return Stack(
      children: [
        Column(
          children: [
            _buildCoverPhoto(), // Kapak Fotoğrafı
            _buildProfileAndStats(), // Kullanıcı Bilgileri ve İstatistikleri
            const Divider(),
            _buildTabs(), // Sekme Kontrolleri
          ],
        ),
        _buildEditButton(), // Düzenle Butonu
      ],
    );
  }

  Future<void> _updateProfilePhoto() async {
    String? newPhotoUrl = await UserServices.uploadProfilePhoto(userUid);

    if (newPhotoUrl != null) {
      setState(() {
        userData!['profilePhotoUrl'] = newPhotoUrl;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil fotoğrafı güncellendi!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fotoğraf yüklenirken hata oluştu!")),
      );
    }
  }

  Widget _buildCoverPhoto() {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            image: userData!['coverPhotoUrl'] != null
                ? DecorationImage(
                    image: NetworkImage(userData!['coverPhotoUrl']),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        Positioned(
          left: 5,
          bottom: 0,
          child: GestureDetector(
            onTap:
                _updateProfilePhoto, // 👈 Fotoğrafı değiştirmek için fonksiyonu çağırıyoruz
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: userData!['profilePhotoUrl'] != null
                  ? NetworkImage(userData!['profilePhotoUrl'])
                  : null,
              child: userData!['profilePhotoUrl'] == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAndStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${userData!['firstName']} ${userData!['lastName'] ?? ''}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "@${userData!['userName']}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            "Meslek: ${userData!['job'] ?? 'Bilinmiyor'}",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "Yaş: ${userData!['age'] ?? 'Bilinmiyor'}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem("9", "Film"),
              _buildStatItem("2", "Takip Edilen"),
              _buildStatItem("2", "Takipçi"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.white, // Seçili sekme rengi
            unselectedLabelColor: Colors.grey, // Seçilmemiş sekme rengi
            indicatorColor: Colors.black, // Alt çizgi rengi
            indicatorWeight: 3, // Alt çizgi kalınlığı
            tabs: const [
              Tab(text: "Film Kutusu"),
              Tab(text: "Film Listesi"),
            //  Tab(text: "Beğenilenler"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(child: FilmKutusu(userUid: userUid)),
                Center(child: FilmListProfile(userUid: userUid)),
               // Center(child: Text("Beğenilenler İçeriği")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return Positioned(
      top: 200,
      right: 10,
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 40,
            child: ElevatedButton(
              onPressed: _updateProfilePhoto,
              child: const Text(
                "Fotoğrafı Güncelle",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
