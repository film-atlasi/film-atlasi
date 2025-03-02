import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/user/services/FollowServices.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/user/widgets/EditProfileScreen.dart';
import 'package:film_atlasi/features/user/widgets/FilmKutusu.dart';
import 'package:film_atlasi/features/user/widgets/FilmListProfile.dart';
import 'package:film_atlasi/features/user/widgets/FollowListWidget.dart';
import 'package:film_atlasi/features/user/widgets/UserProfileRouter.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/widgets/BottomNavigatorBar.dart';

class UserPage extends StatefulWidget {
  final String userUid;
  const UserPage({super.key, required this.userUid});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  User? userData;
  bool isLoading = true;
  bool isFollowingUser = false;
  String? currentUserUid;
  bool followLoading = false;
  int _selectedIndex = 2; // Hesabım sekmesi için 2
  bool isCurrentUser = false;
  int postCount = 0; // 🔥 Post sayısını saklayacak



  FollowServices followServices = FollowServices();

  @override
  void initState() {
    super.initState();
    currentUserUid = auth.FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid == widget.userUid) {
      isCurrentUser = true;
    }
    checkFollowStatus();
    _tabController =
        TabController(length: 3, vsync: this); // TabController length = 3
    _fetchUserData();
     _fetchPostCount(); // 🔥 Post sayısını çekiyoruz
  }

  Future<void> _fetchPostCount() async {
  int count = await getUserPostCount(widget.userUid);
  setState(() {
    postCount = count;
  });
}

Future<int> getUserPostCount(String userId) async {
  try {
    final postSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('posts')
        .get();

    return postSnapshot.docs.length; // 🔥 Mevcut postları sayıyoruz
  } catch (e) {
    print("Post sayısı alınırken hata oluştu: $e");
    return 0; // Eğer hata olursa 0 döndür
  }
}


  

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> checkFollowStatus() async {
    setState(() {
      followLoading = true;
    });
    bool following =
        await followServices.isFollowing(currentUserUid!, widget.userUid);
    setState(() {
      isFollowingUser = following;
      followLoading = false;
    });
  }

  Future<void> toggleFollow() async {
    if (followLoading) {
      return;
    }
    setState(() {
      followLoading = true;
    });
    if (isFollowingUser) {
      //takip ediyorsa takipten çık
      await followServices.unfollowUser(currentUserUid!, widget.userUid);
    } else {
      //etmiyorsa etsin
      final currentUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();
      final currentUserName = currentUser.data()?['userName'];
      final currentUserPhoto = currentUser.data()?["profilePhotoUrl"];
      await followServices.followUser(
          currentUserUid!, widget.userUid, currentUserName, currentUserPhoto);
    }
    checkFollowStatus();
  }

  Future<void> _fetchUserData() async {
    try {
      final auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userUid)
            .get();

        setState(() {
          userData = snapshot.exists ? User.fromFirestore(snapshot) : null;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Kullanıcı verisi çekilirken hata oluştu: $e");
      setState(() => isLoading = false);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
  backgroundColor: Colors.black, // Arka planı siyah yap
  elevation: 0, // Gölgeyi kaldır
  leading: IconButton(
   icon: const Icon(Icons.arrow_back, color: Colors.white),
   onPressed: () {
    Navigator.pop(context);
   },
  ),
  title: Align(
   alignment: Alignment.centerLeft, // Kullanıcı adını sola hizala
   child: Text(
    "${userData?.userName ?? ''}", // Kullanıcı adı buraya gelecek
    style: const TextStyle(color: Colors.white, fontSize: 18),
   ),
  ),
),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text("Kullanıcı bilgileri bulunamadı."))
              : _buildProfileScreenContent(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
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
        ) // Düzenle Butonu
      ],
    );
  }

  Widget _buildCoverPhoto() {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            image: userData!.coverPhotoUrl != null
                ? DecorationImage(
                    image: NetworkImage(userData!.coverPhotoUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        Positioned(
          left: 5,
          bottom: 0,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: userData!.profilePhotoUrl != null
                ? NetworkImage(userData!.profilePhotoUrl!)
                : null,
            child: userData!.profilePhotoUrl == null
                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAndStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${userData!.firstName} ${userData!.lastName!}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    AddVerticalSpace(context, 0.01),
                    Text(
                      "@${userData!.userName}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "Meslek: ${userData!.job ?? 'Bilinmiyor'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Yaş: ${userData!.age ?? 'Bilinmiyor'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: isCurrentUser
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                    userData: userData!.toMap()),
                              ),
                            ).then((_) => _fetchUserData());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey, // Buton rengi
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Düzenle",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: toggleFollow,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: !isFollowingUser
                                      ? AppConstants.red
                                      : Colors.transparent,
                                  border: isFollowingUser
                                      ? Border.all(color: Colors.white)
                                      : null,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              height: MediaQuery.of(context).size.height / 25,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: followLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      isFollowingUser
                                          ? "Takip Ediyorsun"
                                          : "Takip Et",
                                      style: TextStyle(color: Colors.white),
                                    ))))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(postCount.toString(), "Film"),
              _buildStatItem(userData!.following.toString(), "Takip Edilen"),
              _buildStatItem(userData!.followers.toString(), "Takipçi"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return GestureDetector(
      onTap: label == "Takip Edilen"
          ? () {
              buildTakipEdilenler();
            }
          : label == "Takipçi"
              ? () {
                  buildTakipciler();
                }
              : null,
      child: Column(
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
      ),
    );
  }

 Future<dynamic> buildTakipciler() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FollowListWidget(userUid: widget.userUid, isFollowers: true);
      },
    );
  }

  Future<dynamic> buildTakipEdilenler() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FollowListWidget(userUid: widget.userUid, isFollowers: false);
      },
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
                Center(child: FilmKutusu(userUid: widget.userUid)),
                Center(child: FilmListProfile(userUid: widget.userUid)),
                Center(child: Text("Beğenilenler İçeriği")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
