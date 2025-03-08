import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:film_atlasi/app.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key});

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null; // Kullanıcı işlemi iptal ettiyse

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FilmAtlasiApp()),
      );

      return userCredential.user;
    } catch (e) {
      print('Google ile giriş başarısız: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google ile giriş başarısız: $e')),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width * 0.8, // Genişliği dinamik ayarla
      height: 50,
      child: ElevatedButton.icon(
        icon: Image.asset(
          'assets/images/google_logo.png',
          width: 24,
          height: 24,
          fit: BoxFit.cover,
        ),
        label: FittedBox(
          // FittedBox ile sığdır
          fit: BoxFit.scaleDown,
          child: const Text(
            "Google ile Devam Et",
            style: TextStyle(fontSize: 16),
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => signInWithGoogle(context),
      ),
    );
  }
}
