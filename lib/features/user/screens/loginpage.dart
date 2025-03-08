import 'package:film_atlasi/app.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_atlasi/features/user/widgets/GoogleAuthButton.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  late String email;
  late String password;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formkey =
      GlobalKey<FormState>(); //form key oluşturuldu
  final firebaseAuth = FirebaseAuth.instance;

  final bool _obscurePassword =
      true; // Şifreyi gizlemek için kullanılan değişken
  bool _isHovering = false;
  // Butona fare ile üzerine gelindi mi kontrolü
  @override
  void initState() {
    super.initState();
    _emailController.text = "sidar123@gmail.com";
    _passwordController.text = "sidar123";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo2.png'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // Email ve şifre TextField'ları
                      AddVerticalSpace(context, 0.02),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bilgileri eksiksiz giriniz';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value!;
                        },
                      ),
                      AddVerticalSpace(context, 0.01),
                      TextFormField(
                        controller: _passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bilgileri eksiksiz giriniz';
                          }
                          if (value.length < 6) return 'too short';
                          if (value.length > 15) return 'too long';
                          return null;
                        },
                        onSaved: (value) {
                          password = value!;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Email ile Giriş Yap Butonu
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FilmAtlasiApp()),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Giriş başarısız: $e')),
                              );
                            }
                          }
                        },
                        child: const Text('Giriş Yap'),
                      ),

                      const SizedBox(height: 20),

                      // 🔥 Google ile Giriş Yap Butonu burada eklendi:
                      const GoogleAuthButton(),

                      const SizedBox(height: 30),

                      // Kayıt ol linki
                      Column(
                        children: [
                          const Text('Hesabınız yok mu?'),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/kaydol');
                            },
                            child: Text('@kaydol',
                                style: TextStyle(
                                  color: AppConstants.highlightColor,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
