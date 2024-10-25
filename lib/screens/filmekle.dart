import 'package:flutter/material.dart';

class FilmEkleWidget extends StatefulWidget {
  @override
  _FilmEkleWidgetState createState() => _FilmEkleWidgetState();
}

class _FilmEkleWidgetState extends State<FilmEkleWidget> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.4,
      padding: const EdgeInsets.all(20.0), // Kenar boşlukları için padding
      decoration: const BoxDecoration(
        color: Colors.black, // Arka plan rengi siyah
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Sola hizalı
        children: [
          const Text(
            'Yeni Film Ekleyin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20), // Başlıkla ikonlar arası boşluk

          // İkon ve yazılar
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.white),
                  title: const Text(
                    'Film İncelemesi Yaz',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Butona basıldığında yapılacaklar
                    // Film inceleme yazma ekranını aç

                    showModalBottomSheet(
                      backgroundColor:
                          const Color.fromARGB(255, 0, 0, 0), // Modal açılır
                      context: context, // Context
                      builder: (BuildContext context) {
                        // Modal içeriği
                        return SizedBox(
                          height: 600,
                          child: FilmIncelemesiYaz(),
                        ); // Film ekleme widget'ı
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.format_quote, color: Colors.white),
                  title: const Text(
                    'Filmden Alıntı Paylaş',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Tıklandığında yapılacaklar
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.message, color: Colors.white),
                  title: const Text(
                    'İleti Paylaş',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Tıklandığında yapılacaklar
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book, color: Colors.white),
                  title: const Text(
                    'Filmi Favorilere Ekle',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Tıklandığında yapılacaklar
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.track_changes, color: Colors.white),
                  title: const Text(
                    'Okuma Hedefi',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Tıklandığında yapılacaklar
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilmIncelemesiYaz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Film İncelemesi Yaz',
            style: TextStyle(color: Colors.white), textAlign: TextAlign.left),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 0, 0, 0), // Buton rengi
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.white, width: 2), // Kenar çizgisi
                    borderRadius:
                        BorderRadius.circular(15), // Köşeleri köşeli yapar
                  ),
                ),
                onPressed: () {
                  // Butona basıldığında yapılacaklar
                },
                child: const Text(
                  'Film Ara',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Örnek olarak 10 film
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.movie, color: Colors.white),
                  title: Text('Film ${index + 1}',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text('Film açıklaması ${index + 1}',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Film seçildiğinde yapılacaklar
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
