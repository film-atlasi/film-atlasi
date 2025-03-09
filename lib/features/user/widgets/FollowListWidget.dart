import 'package:flutter/material.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/user/services/FollowServices.dart';
import 'package:film_atlasi/features/user/widgets/UserProfileRouter.dart';

class FollowListWidget extends StatelessWidget {
  final String userUid;
  final bool isFollowers;
  final FollowServices followServices = FollowServices();

  FollowListWidget({required this.userUid, required this.isFollowers});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isFollowers ? "Takipçiler" : "Takip Edilenler"),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: isFollowers
                  ? followServices.getFollowers(userUid)
                  : followServices.getFollowings(userUid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Hata: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(isFollowers
                      ? "Takipçi bulunamadı."
                      : "Takip edilen kullanıcı bulunamadı.");
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
  }
}