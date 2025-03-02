import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:film_atlasi/features/user/widgets/EditProfileScreen.dart';
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

  Future<int> getPostCount(String userId) async {
  final postsRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('posts');

  try {
    final postSnapshot = await postsRef.get();
    return postSnapshot.docs.length; // 🔥 Mevcut postları sayıyoruz
  } catch (e) {
    print("Post sayısı alınırken hata oluştu: $e");
    return 0; // Eğer hata olursa 0 döndür
  }
}

  Future<void> _fetchUserData() async {
    try {
      final auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
            final postCount = await getPostCount(currentUser.uid); // 🔥 Post sayısını getir

        setState(() {
          userUid = currentUser.uid;
          userData = snapshot.exists ? snapshot.data() : null;
             userData?['postCount'] = postCount; // 🔥 Post sayısını burada saklıyoruz
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
      ],
    );
  }

  Future<void> _updateCoverPhoto() async {
    String? newCoverUrl = await UserServices.uploadCoverPhoto(userUid);

    if (newCoverUrl != null) {
      setState(() {
        userData!['coverPhotoUrl'] = newCoverUrl;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kapak fotoğrafı güncellendi!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Kapak fotoğrafı yüklenirken hata oluştu!")),
      );
    }
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
      clipBehavior:
          Clip.none, // Stack'in dışına taşan widget'ları göstermek için
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
          left: 20, // Profil fotoğrafını biraz sağa kaydırmak için
          bottom: -40, // Fotoğrafın yarısını dışarı taşırmak için
          child: GestureDetector(
            onTap: _updateProfilePhoto,
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
          const SizedBox(
              height: 30), // Profil fotoğrafı ile çakışmayı önlemek için
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${userData!['firstName']} ${userData!['lastName'] ?? ''}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "@${userData!['userName']}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfileScreen(userData: userData!),
                    ),
                  ).then((_) => _fetchUserData());
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey, // Buton rengi
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Düzenle",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Meslek: ${userData!['job'] ?? 'Bilinmiyor'}",
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            "Yaş: ${userData!['age'] ?? 'Bilinmiyor'}",
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(userData?['postCount'].toString() ?? "0", "Gönderi"),
              _buildStatItem(userData!['following'].toString(), "Takip Edilen"),
              _buildStatItem(userData!['followers'].toString(), "Takipçi"),
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
              Tab(text: "Beğenilenler"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(child: FilmKutusu(userUid: userUid)),
                Center(child: FilmListProfile(userUid: userUid)),
                Center(child: Text("Beğenilenler İçeriği")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
