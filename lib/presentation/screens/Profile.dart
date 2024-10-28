// ignore: file_names
import 'package:film_atlasi/data/models/Film.dart';
import 'package:film_atlasi/data/models/User.dart';
import 'package:film_atlasi/utils/helpers.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final Film finalFilm = Film(
      poster:
          "https://m.media-amazon.com/images/M/MV5BMTk5MzU1MDMwMF5BMl5BanBnXkFtZTcwNjczODMzMw@@._V1_SX300.jpg");
  late User user = User(
      name: "Sidar",
      surname: "Adıgüzel",
      username: "sidaradiguzel",
      birthDate: DateTime(2001, 12, 25),
      job: "Software Engineer",
      currentlyWatchingFilm: finalFilm,
      books: 6,
      following: 2,
      followers: 2,
      reviews: 0,
      quotes: 0,
      messages: 0,
      profilePhotoUrl:
          "https://m.media-amazon.com/images/M/MV5BM2MwZjI2YjYtNGZmMS00MGMxLWE0MzMtZTdhMjA3NzA0N2M3XkEyXkFqcGc@._V1_SX300.jpg");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

// wqe
  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Metinleri sola hizala
          children: [
            // Kapak Fotoğrafı
            Container(
              height: MediaQuery.of(context).size.height * 0.18,
              width: double.infinity, //999
              decoration: const BoxDecoration(
                color: Colors.grey, // Kapak fotoğrafı için yer tutucu
              ),
            ),
            // Profil Fotoğrafı
            Transform.translate(
              offset: const Offset(
                  20, -50), // Profil fotoğrafını kapak fotoğrafının altına taşı
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.profilePhotoUrl.toString()),
                child: user.profilePhotoUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      )
                    : null,
                // Profil fotoğrafı boş bırakıldı
              ),
            ), // Profil fotoğrafı ile isim arasında boşluk

            // Ad Soyad ve Şu An İzlediği Film
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user.name} ${user.surname}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "@${user.username}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors
                              .grey[600], // Kullanıcı adı rengi daha hafif
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Şu An İzlediği Film",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      AddVerticalSpace(context, 0.01),
                      SizedBox(
                          width: 80,
                          child: Image.network(
                              user.currentlyWatchingFilm!.poster.toString(),
                              fit: BoxFit.fitWidth,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.movie,
                                    size: 50,
                                    color: Colors.grey,
                                  ))),
                    ],
                  ),
                ],
              ),
            ),
            // Meslek
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Meslek: ${user.job.toString()}", // Örnek meslek
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),

            // Doğum Tarihi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Doğum Tarihi: ${formatDate(user.birthDate)}", // Örnek doğum tarihi
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),

            // Bilgiler (Kitap, Takip edilen, Takipçi vb.)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Kitap
                  Column(
                    children: [
                      Text(user.books.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text("Kitap"),
                    ],
                  ),
                  // Takip Edilen
                  Column(
                    children: [
                      Text("2", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Takip edilen"),
                    ],
                  ),
                  // Takipçi
                  Column(
                    children: [
                      Text("2", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Takipçi"),
                    ],
                  ),
                  // İnceleme
                  Column(
                    children: [
                      Text("0", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("İnceleme"),
                    ],
                  ),
                  // Alıntı
                  Column(
                    children: [
                      Text("0", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Alıntı"),
                    ],
                  ),
                  // İleti
                  Column(
                    children: [
                      Text("0", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("İleti"),
                    ],
                  ),
                ],
              ),
            ),

            // TabBar ekleyelim
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                tabs: const [
                  Tab(text: 'Film Kutusu'),
                  Tab(text: 'Duvar'),
                  Tab(text: 'İncelemeler'),
                  Tab(text: 'Alıntılar'),
                  Tab(text: 'İletiler'),
                  Tab(text: 'Hedefler'),
                ],
              ),
            ),

            // TabBarView içeriği
            SizedBox(
              height: 300, // TabBarView'in yüksekliği
              child: TabBarView(
                controller: _tabController,
                children: const [
                  Center(child: Text('Film Kutusu İçeriği')),
                  Center(child: Text('Duvar İçeriği')),
                  Center(child: Text('İncelemeler İçeriği')),
                  Center(child: Text('Alıntılar İçeriği')),
                  Center(child: Text('İletiler İçeriği')),
                  Center(child: Text('Hedefler İçeriği')),
                ],
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
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert), // Menü simgesi
          onPressed: () {
            showMenu(
              context: context,
              position:
                  const RelativeRect.fromLTRB(100, 80, 0, 0), // Menü pozisyonu
              items: const [
                PopupMenuItem(
                  child: Text('Ayarlar'),
                ),
                PopupMenuItem(
                  child: Text('Çıkış'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
