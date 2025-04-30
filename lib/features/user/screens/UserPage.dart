import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/widgets/LoadingWidget.dart';
import 'package:film_atlasi/features/user/services/FollowServices.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/user/widgets/BegeniListesi.dart';
import 'package:film_atlasi/features/user/widgets/EditProfileScreen.dart';
import 'package:film_atlasi/features/user/widgets/FilmKutusu.dart';
import 'package:film_atlasi/features/user/widgets/FilmListProfile.dart';
import 'package:film_atlasi/features/user/widgets/FollowListWidget.dart';
import 'package:film_atlasi/features/user/widgets/Kaydedilenler.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  String? currentUserUid;
  bool followLoading = false;
  bool isCurrentUser = false;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isUploading = false;

  FollowServices followServices = FollowServices();

  @override
  void initState() {
    super.initState();
    currentUserUid = auth.FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid == widget.userUid) {
      isCurrentUser = true;
    }
    _tabController = TabController(length: 3, vsync: this);
    _fetchUserData();
  }

  Future<void> toggleFollow(String type) async {
    if (!mounted) return;
    if (followLoading) {
      return;
    }
    setState(() {
      followLoading = true;
    });
    if (type == "unfollow") {
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

// kullanıcının postlarını sayıyoruz
  Future<int> getPostCount(String userId) async {
    if (!mounted) return 0;
    final postsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('posts');

    try {
      final postSnapshot = await postsRef.get();
      return postSnapshot.docs.length; // 🔥 Mevcut postları sayıyoruz
    } catch (e) {
      return 0; // Eğer hata olursa 0 döndür
    }
  }

  Future<void> _fetchUserData() async {
    try {
      if (!mounted) return;
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
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleImageSelection(bool isProfilePhoto) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _isUploading = true);

        final File imageFile = File(image.path);
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${isProfilePhoto ? "profile" : "cover"}.jpg';
        final Reference ref = FirebaseStorage.instance.ref().child(
            'users/${widget.userUid}/${isProfilePhoto ? "profile" : "cover"}/$fileName');

        await ref.putFile(imageFile);
        final String downloadUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userUid)
            .update({
          isProfilePhoto ? 'profilePhotoUrl' : 'coverPhotoUrl': downloadUrl,
        });

        setState(() {
          if (isProfilePhoto) {
            userData!.profilePhotoUrl = downloadUrl;
          } else {
            userData!.coverPhotoUrl = downloadUrl;
          }
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fotoğraf yüklenirken bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppConstants appConstants = AppConstants(context);
    return Scaffold(
      appBar: !widget.fromProfile ? AppBar() : null,
      body: RefreshIndicator(
        // 🔥 AŞAĞI KAYDIRINCA SAYFA YENİLENECEK
        onRefresh: () async {
          await _fetchUserData();
        },
        child: isLoading
            ? LoadingWidget()
            : userData == null
                ? const Center(child: Text("Kullanıcı bilgileri bulunamadı."))
                : _buildUserProfile(appConstants),
      ),
    );
  }

  Widget _buildUserProfile(AppConstants appConstants) {
    return NestedScrollView(
      controller: ScrollController(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            pinned: true,
            floating: true,
            leading: SizedBox(),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfilePhoto(appConstants),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                color: appConstants.appBarColor,
                child: TabBar(
                  controller: _tabController,
                  labelColor: appConstants.textLightColor,
                  unselectedLabelColor: appConstants.textLightColor,
                  indicatorColor: appConstants.primaryColor,
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
      body: isLoading
          ? LoadingWidget()
          : TabBarView(
              controller: _tabController,
              children: [
                FilmKutusu(userUid: widget.userUid),
                FilmListProfile(userUid: widget.userUid),
                isCurrentUser
                    ? Kaydedilenler(
                        userUid: widget.userUid,
                      )
                    : BegeniListesi(userUid: widget.userUid),
              ],
            ),
    );
  }

  Widget _buildProfilePhoto(AppConstants appConstants) {
    return Container(
      color: appConstants.appBarColor,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Kapak Fotoğrafı
              GestureDetector(
                onTap: () => _handleImageSelection(false),
                child: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                    color: appConstants.textLightColor,
                    image: userData!.coverPhotoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(userData!.coverPhotoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: userData!.coverPhotoUrl == null
                      ? Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            size: 40,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        )
                      : null,
                ),
              ),
              // Profil Fotoğrafı
              Positioned(
                bottom: MediaQuery.of(context).size.height * -0.03,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () => _handleImageSelection(true),
                    child: ClipOval(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: appConstants.appBarColor,
                            width: 5,
                          ),
                        ),
                        child: userData!.profilePhotoUrl != null &&
                                userData!.profilePhotoUrl!.isNotEmpty
                            ? Image.network(
                                userData!.profilePhotoUrl!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey.shade800,
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_isUploading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
          AddVerticalSpace(context, 0.05),
          _buildProfileAndStats(appConstants),
        ],
      ),
    );
  }

  Widget _buildProfileAndStats(AppConstants appConstants) {
    return Column(
      children: [
        Text(
          "${userData!.firstName} ${userData!.lastName ?? ''}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          "@${userData!.userName}",
          style: TextStyle(color: appConstants.textLightColor, fontSize: 12),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(userData!.posts.toString(), "Gönderi", appConstants),
            _buildStatItem(
                userData!.following.toString(), "Takip Edilen", appConstants),
            _buildStatItem(
                userData!.followers.toString(), "Takipçi", appConstants),
          ],
        ),
        const SizedBox(height: 10),
        isCurrentUser
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                          userMap: userData!.toMap(), userId: widget.userUid),
                    ),
                  ).then((_) => _fetchUserData());
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: appConstants.textLightColor, // Buton rengi
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Düzenle",
                    style: TextStyle(
                        color: appConstants.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : StreamBuilder(
                stream: followServices.isFollowingStream(
                    currentUserUid!, widget.userUid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  bool isFollowingUser = snapshot.data!;
                  return ElevatedButton(
                    onPressed: () =>
                        toggleFollow(isFollowingUser ? "unfollow" : "follow"),
                    child:
                        Text(isFollowingUser ? "Takip Ediliyor" : "Takip Et"),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, AppConstants appConstants) {
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
            style: TextStyle(fontSize: 14, color: appConstants.textLightColor),
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
