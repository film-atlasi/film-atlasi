import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:film_atlasi/features/movie/screens/FilmAsistani.dart/MovieFilterFlow.dart';

class MovieIntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppConstants appConstants = AppConstants(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Film Asistanı"),
        centerTitle: true,
        backgroundColor: appConstants.scaffoldColor,
        elevation: 0,
      ),
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
                    backgroundColor: appConstants.primaryColor,
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
        ],
      ),
    );
  }
}
