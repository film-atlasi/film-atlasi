import 'package:film_atlasi/features/movie/screens/Anasayfa.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:film_atlasi/features/movie/screens/FilmAsistani.dart/MovieFilterFlow.dart';

class MovieIntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Animasyon (Lottie)
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Lottie.asset(
                    'assets/animations/movie_intro.json', // Lottie animasyon dosyanı buraya ekle
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: 20),

                // Açıklama
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "📽️ Kararsız mısın? Film dünyasına dalmanın zamanı geldi! 🚀\n"
                    "En iyi önerileri senin için hazırladık. Hadi, mükemmel filmi birlikte keşfedelim! 🎬✨",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 30),

                // Başla Butonu
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Kullanıcıyı filtreleme akışına yönlendir
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MovieFilterFlow()),
                    );
                  },
                  child: Text(
                    "Keşfetmeye Başla!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 📌 Sol üst köşeye geri butonu eklendi
          Positioned(
            top: 40, // Yukarıdan boşluk
            left: 10, // Soldan boşluk
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                // 🎯 Eğer geri gidilecek bir sayfa varsa geri dön, yoksa anasayfaya git
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Anasayfa()), // 🏠 Anasayfaya yönlendirme
                    (route) => false, // 🔥 Önceki tüm sayfaları temizle
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
