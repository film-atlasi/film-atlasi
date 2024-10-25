import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

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
      appBar: AppBar(
        title: Text('Profil Ekranııı'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert), // Menü simgesi
            onPressed: () {
              showMenu(
                context: context,
                position:
                    RelativeRect.fromLTRB(100, 80, 0, 0), // Menü pozisyonu
                items: [
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Metinleri sola hizala
          children: [
            // Kapak Fotoğrafı
            Container(
              height: 200,
              width: double.infinity, //999
              decoration: BoxDecoration(
                color: Colors.grey, // Kapak fotoğrafı için yer tutucu
              ),
            ),
            // Profil Fotoğrafı
            Transform.translate(
              offset: Offset(
                  20, -50), // Profil fotoğrafını kapak fotoğrafının altına taşı
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                // Profil fotoğrafı boş bırakıldı
              ),
            ),
            SizedBox(height: 10), // Profil fotoğrafı ile isim arasında boşluk

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
                        "Ad Soyad",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "@kullaniciadi",
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
                      Text(
                        "Şu An İzlediği Film",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 70, // Kare alan boyutu
                        height: 70,
                        color: Colors.grey[300], // Placeholder renginde
                        child: Center(
                          child: Text(
                            "Film", // Boş placeholder
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 10), // Meslek ve doğum tarihi arasında boşluk

            // Meslek
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Meslek: ", // Örnek meslek
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),

            // Doğum Tarihi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Doğum Tarihi: ", // Örnek doğum tarihi
                style: TextStyle(
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
                      Text("6", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Kitap"),
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
                tabs: [
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
                children: [
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
}
