import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/user/services/FollowServices.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/user/widgets/FilmKutusu.dart';
import 'package:film_atlasi/features/user/widgets/FilmListProfile.dart';
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

  FollowServices followServices = FollowServices();

  @override
  void initState() {
    super.initState();
    currentUserUid = auth.FirebaseAuth.instance.currentUser?.uid;
    checkFollowStatus();
    _tabController =
        TabController(length: 3, vsync: this); // TabController length = 3
    _fetchUserData();
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
      await followServices.followUser(currentUserUid!, widget.userUid);
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
        backgroundColor: Colors.transparent,
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
                  child: GestureDetector(
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
              _buildStatItem("9", "Film"),
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
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Takipçiler"),
              Expanded(
                child: FutureBuilder<List<User>>(
                  future: followServices.getFollowers(widget.userUid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text("Hata: ${snapshot.error}");
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("Takipçi bulunamadı.");
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          User user = snapshot.data![index];
                          return UserProfileRouter(
                            userId: user.uid!,
                            title: user.userName!,
                            profilePhotoUrl: user.profilePhotoUrl!,
                            subtitle: user.firstName,
                          );
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> buildTakipEdilenler() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Takip Edilenler"),
              Expanded(
                child: FutureBuilder<List<User>>(
                  future: followServices.getFollowings(widget.userUid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text("Hata: ${snapshot.error}");
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("Takip edilen kullanıcı bulunamadı.");
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          User user = snapshot.data![index];
                          return UserProfileRouter(
                            userId: user.uid!,
                            title: user.userName!,
                            profilePhotoUrl: user.profilePhotoUrl!,
                            subtitle: user.firstName,
                          );
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        );
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
