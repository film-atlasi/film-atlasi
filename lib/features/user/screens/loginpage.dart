import 'package:film_atlasi/app.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email;
  late String password;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController.text = "sidar123@gmail.com";
    _passwordController.text = "sidar123";
  }

  @override
  Widget build(BuildContext context) {
    final AppConstants appConstants = AppConstants(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text('Film Atlasidir', style: TextStyle(fontSize: 30)),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bilgileri eksiksiz giriniz';
                          }
                          return null;
                        },
                        onSaved: (value) => email = value!,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bilgileri eksiksiz giriniz';
                          }
                          if (value.length < 6) {
                            return 'Şifre çok kısa';
                          }
                          if (value.length > 15) {
                            return 'Şifre çok uzun';
                          }
                          return null;
                        },
                        onSaved: (value) => password = value!,
                      ),
                      const SizedBox(height: 5),

                      // Şifreni mi unuttun? yazısı
                      const SizedBox(height: 5),

                      // Şifreni mi unuttun? yazısı (alt çizgisiz)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            // Şifre sıfırlama sayfasına yönlendirme kodu buraya eklenebilir
                            print("Şifremi unuttum tıklandı.");
                          },
                          child: Text(
                            'Şifreni mi unuttun?',
                            style: TextStyle(
                              color: Colors
                                  .blue, // Mavi renk (link gibi görünmesi için)
                              // decoration: TextDecoration.underline, // Altı çizgili olan kod kaldırıldı
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState != null &&
                              formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            try {
                              final userResult =
                                  await firebaseAuth.signInWithEmailAndPassword(
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Kullanıcı adı veya şifre hatalı'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            print(
                                "Form doğrulama başarısız veya form initialize edilmedi.");
                          }
                        },
                        child: Text(
                          'Giriş Yap',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                          height: 30), // Daha aşağı almak için boşluk eklendi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hesabın mı yok? ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                                context, '/kaydol'),
                            child: Text(
                              "Kaydol",
                              style: TextStyle(
                                color: Colors.blue, // Mavi renk
                                fontSize: 16,
                                fontWeight: FontWeight.bold, // Kalın font
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
