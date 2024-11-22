import 'package:film_atlasi/features/movie/widgets/Button1.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool _obscurePassword = true; // Şifreyi gizlemek için kullanılan değişken
  bool _isHovering = false; // Butona fare ile üzerine gelindi mi kontrolü

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 1, 2),
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
                child: Column(
                  children: [
                    // Kullanıcı Adı TextField
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Kullanıcı Adı',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),

                    // Şifre TextField
                    TextField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Şifre',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
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
                        child: Button1(_isHovering, context)),

                    // Kaydol kısmı
                    Padding(
                      padding: const EdgeInsets.only(
                          top:
                              20), // Metni biraz daha aşağıya çekmek için boşluk ekledik
                      child: Column(
                        children: [
                          Text(
                            'Hesabınız yok mu ?',
                            style: TextStyle(
                                color: Colors.white), // Yazı rengi beyaz
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
                            child: Text(
                              '@kaydol',
                              style: TextStyle(
                                color:
                                    Colors.blue, // Kaydol yazısının rengi mavi
                                fontWeight: FontWeight.bold, // Kalın yazı stili
                                fontSize: 14, // Yazı boyutu küçültüldü
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
