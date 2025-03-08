import 'package:film_atlasi/features/movie/screens/FilmAsistani.dart/MovieFilterFlow.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:film_atlasi/features/movie/screens/FilmAsistani.dart/MovieFilterFlow.dart';

class MovieIntroPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animasyon (Lottie)
          Lottie.asset(
            'assets/animations/movie_intro.json', // Lottie animasyon dosyanı buraya ekle
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          ),

          SizedBox(height: 20),

          // Açıklama
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Hangi filmi izlemelisin? Seni en iyi önerilerle buluşturuyoruz! 🚀",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.4,
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
              // Kullanıcıyı soru akışına yönlendir
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MovieFilterFlow()),
              );
            },
            child: Text(
              "Başla!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
