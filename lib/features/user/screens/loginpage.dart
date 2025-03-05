import 'package:film_atlasi/app.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo2.png'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // Kullanıcı Adı TextField
                      AddVerticalSpace(context, 0.02),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bilgileri eksiksiz girininz';
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
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bilgileri eksiksiz girininiz';
                          }
                          if (value.length < 6) {
                            return 'too short';
                          }
                          if (value.length > 15) {
                            return 'too long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password = value!;
                        },
                        obscureText: true,
                      ),
                      SizedBox(height: 20),

                      // Giriş Yap Butonu
                      MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              _isHovering =
                                  true; // Fare butonun üzerine geldiğinde
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              _isHovering = false; // Fare butondan ayrıldığında
                            });
                          },
                          child: TextButton(
                            onPressed: () async {
                              if (formKey.currentState != null &&
                                  formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                try {
                                  final userResult = await firebaseAuth
                                      .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  print(
                                      'Giriş başarılı: ${userResult.user!.email}');
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FilmAtlasiApp()),
                                  );
                                } catch (e) {
                                  print('Hata oluştu: $e');
                                }
                              } else {
                                print(
                                    "Form doğrulama başarısız veya form initialize edilmedi.");
                              }
                            },
                            child: Text(
                              'Giriş Yap',
                            ),
                          )),

                      // Kaydol kısmı
                      Padding(
                        padding: const EdgeInsets.only(
                            top:
                                20), // Metni biraz daha aşağıya çekmek için boşluk ekledik
                        child: Column(
                          children: [
                            Text(
                              'Hesabınız yok mu ?',
                            ),
                            SizedBox(
                                height:
                                    8), // Hesabınız yok mu? ve Kaydol arasında boşluk ekledik
                            GestureDetector(
                              onTap: () {
                                // Kaydol sayfasına yönlendirme işlemi
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
