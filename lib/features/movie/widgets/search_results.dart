import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/user/widgets/UserProfileRouter.dart';
import 'package:flutter/material.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/features/user/models/User.dart';
import 'package:film_atlasi/features/movie/screens/IletiPaylas.dart';
import 'package:film_atlasi/features/movie/widgets/FilmList.dart';
import 'package:film_atlasi/features/user/screens/UserPage.dart';

class SearchResults extends StatelessWidget {
  final List<dynamic> searchResults;
  final String mode; // Mode parametresi eklendi

  const SearchResults(
      {super.key, required this.searchResults, required this.mode});

  @override
  Widget build(BuildContext context) {
    final AppConstants appConstants = AppConstants(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 25),
      child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final result = searchResults[index];
          if (result is Movie) {
            return _buildMovieListTile(result, context, appConstants);
          } else if (result is User) {
            return UserProfileRouter(
                userId: result.uid!,
                title: result.firstName!,
                subtitle: result.userName,
                profilePhotoUrl: result.profilePhotoUrl!);
          }
          return Container();
        },
      ),
    );
  }

  ListTile _buildMovieListTile(
      Movie movie, BuildContext context, AppConstants appConstants) {
    return ListTile(
      leading: movie.posterPath.isNotEmpty
          ? Image.network(
              'https://image.tmdb.org/t/p/w92${movie.posterPath}',
              width: 50,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.movie, color: appConstants.textColor),
            )
          : Icon(Icons.movie, color: appConstants.textColor),
      title: Text(movie.title, style: TextStyle(color: appConstants.textColor)),
      subtitle: Text(
        movie.overview.length > 50
            ? '${movie.overview.substring(0, 50)}...'
            : movie.overview,
        style: TextStyle(color: appConstants.textLightColor),
      ),
      contentPadding: EdgeInsets.all(0),
      onTap: () {
        // 📌 Eğer mod "film_listesi" ise, aşağıdan modal açalım
        if (mode == "film_listesi") {
          showModalBottomSheet(
            context: context,
            backgroundColor: appConstants.backgroundColor,
            isScrollControlled: true, // 🔥 Sayfanın %80'ini kaplayacak şekilde
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height *
                  0.7, // 🔥 %80 oranında aç
            ),
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(14.0),
                child: FilmList(selectedMovie: movie),
              );
            },
          );
        } else if (mode == "film_alinti") {
          // 🔥 Eğer alıntı paylaşımıysa
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Iletipaylas(
                  movie: movie, isFromQuote: true), // 💡 Özel parametre ekledik
            ),
          );
        } else {
          // Normalde ileti paylaşım ekranına yönlendir
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Iletipaylas(movie: movie, isFromQuote: false),
            ),
          );
        }
      },
    );
  }

  ListTile _buildUserListTile(
      User user, BuildContext context, AppConstants appConstants) {
    return ListTile(
      leading: user.profilePhotoUrl != null && user.profilePhotoUrl!.isNotEmpty
          ? CircleAvatar(
              backgroundImage: NetworkImage(
                  user.profilePhotoUrl!), // Kullanıcının profil fotoğrafı
            )
          : CircleAvatar(
              backgroundColor: appConstants
                  .textLightColor, // Fotoğraf yoksa sadece gri bir avatar
              child: Icon(Icons.person,
                  color: appConstants.textColor), // Kullanıcı ikonu
            ),
      title: Text(user.userName ?? "username",
          style: TextStyle(color: appConstants.textColor)),
      subtitle: Text(
        user.firstName ?? "first name",
        style: TextStyle(color: appConstants.textLightColor),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserPage(userUid: user.uid!),
          ),
        );
      },
    );
  }
}
