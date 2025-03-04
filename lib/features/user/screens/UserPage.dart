import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/user/services/FollowServices.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/user/services/UserServices.dart';
import 'package:film_atlasi/features/user/widgets/EditProfileScreen.dart';
import 'package:film_atlasi/features/user/widgets/FilmKutusu.dart';
import 'package:film_atlasi/features/user/widgets/FilmListProfile.dart';
import 'package:film_atlasi/features/user/widgets/FollowListWidget.dart';
import 'package:film_atlasi/features/user/widgets/Kaydedilenler.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final String userUid;
  final bool fromProfile;
  const UserPage({super.key, required this.userUid, this.fromProfile = false});

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
  bool isCurrentUser = false;

  FollowServices followServices = FollowServices();

  @override
  void initState() {
    super.initState();
    currentUserUid = auth.FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid == widget.userUid) {
      isCurrentUser = true;
    }
    checkFollowStatus();
    _tabController = TabController(length: 3, vsync: this);
    _fetchUserData();
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

// kullanıcının postlarını sayıyoruz
  Future<int> getPostCount(String userId) async {
    final postsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('posts');

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
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userUid)
          .get();
      final postCount =
          await getPostCount(widget.userUid); // 🔥 Post sayısını getir
      setState(() {
        userData = snapshot.exists ? User.fromFirestore(snapshot) : null;
        userData!.posts = postCount; // 🔥 Post sayısını ekliyoruz
        isLoading = false;
      });
    } catch (e) {
      print("Kullanıcı verisi çekilirken hata oluştu: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateProfilePhoto() async {
    String? newPhotoUrl = await UserServices.uploadProfilePhoto(widget.userUid);

    if (newPhotoUrl != null) {
      setState(() {
        userData!.profilePhotoUrl = newPhotoUrl;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !widget.fromProfile
          ? AppBar(
              title: Text(userData?.userName ?? ""),
            )
          : null,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text("Kullanıcı bilgileri bulunamadı."))
              : _buildUserProfile(),
    );
  }

  Widget _buildUserProfile() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            pinned: true,
            floating: true,
            leading: SizedBox(),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildCoverPhoto(),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                color: Colors.black,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.red,
                  tabs: [
                    Tab(text: "Film Kutusu"),
                    Tab(text: "Film Listesi"),
                    isCurrentUser
                        ? Tab(
                            text: "Kaydedilenler",
                          )
                        : Tab(text: "Beğenilenler"),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          FilmKutusu(userUid: widget.userUid),
          FilmListProfile(userUid: widget.userUid),
          isCurrentUser ? const Kaydedilenler() : const Text("Beğenilenler"),
        ],
      ),
    );
  }

  Widget _buildCoverPhoto() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
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
              bottom: MediaQuery.of(context).size.height * -0.03,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: _updateProfilePhoto,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    // ignore: unnecessary_null_comparison
                    backgroundImage: userData!.profilePhotoUrl! != null
                        ? NetworkImage(userData!.profilePhotoUrl!)
                        : null,
                    child: userData!.profilePhotoUrl == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
        AddVerticalSpace(context, 0.03),
        _buildProfileAndStats(),
      ],
    );
  }

  Widget _buildProfileAndStats() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "${userData!.firstName} ${userData!.lastName ?? ''}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            "@${userData!.userName}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(userData!.posts.toString(), "Gönderi"),
              _buildStatItem(userData!.following.toString(), "Takip Edilen"),
              _buildStatItem(userData!.followers.toString(), "Takipçi"),
            ],
          ),
          const SizedBox(height: 10),
          isCurrentUser
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfileScreen(userData: userData!.toMap()),
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
                )
              : ElevatedButton(
                  onPressed: toggleFollow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFollowingUser ? Colors.grey : AppConstants.red,
                  ),
                  child: followLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          isFollowingUser ? "Takip Ediliyor" : "Takip Et",
                          style: const TextStyle(color: Colors.white),
                        ),
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
}
