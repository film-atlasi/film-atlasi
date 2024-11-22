import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/user/screens/loginpage.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isHovering = false; // Butona fare ile üzerine gelindi mi kontrolü

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 1, 2),
      appBar: AppBar(
        title: Text('Kayıt Ol'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AddVerticalSpace(context, 0.01),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.fitHeight),
                    ),
                  ),
                ), // Logo boyutunu ayarlayın

                AddVerticalSpace(context, 0.1),

                // Hoşgeldiniz mesajı
                Text(
                  'Film Atlası\'na Hoşgeldiniz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20, // Yazı boyutunu küçültüyoruz
                    fontWeight: FontWeight.bold, // Kalın yazı stili
                  ),
                ),
                AddVerticalSpace(
                    context, 0.02), // Mesaj ile input alanları arasında boşluk

                // Kullanıcı Adı TextField
                _buildTextField('Kullanıcı Adı', _usernameController),

                AddVerticalSpace(context, 0.01),

                // Şifre TextField
                _buildTextField('Şifre', _passwordController,
                    obscureText: true),

                AddVerticalSpace(context, 0.01),

                // İsim TextField
                _buildTextField('İsim', _firstNameController),

                AddVerticalSpace(context, 0.01),

                // Soyisim TextField
                _buildTextField('Soyisim', _lastNameController),

                AddVerticalSpace(context, 0.01),

                // Şehir TextField
                _buildTextField('Şehir', _cityController),

                AddVerticalSpace(context, 0.01),

                // Yaş TextField
                _buildTextField('Yaş', _ageController),

                AddVerticalSpace(context, 0.01),

                // Kayıt Ol Butonu
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovering = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovering = false;
                    });
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Loginpage()),
                      );
                    },
                    child: Text(
                      'Kaydol',
                      style: TextStyle(
                        color: _isHovering
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isHovering
                          ? const Color.fromARGB(255, 255, 255, 255)
                          : const Color.fromARGB(255, 0, 0, 0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: Colors.transparent), // Kenarları kaldırdım
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TextField oluşturmak için bir fonksiyon
  Widget _buildTextField(String hintText, TextEditingController controller,
      {bool obscureText = false}) {
    return Container(
      width: double.infinity, // Genişliği tam yap
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 12), // Yazı boyutunu buradan ayarlayın
          border: UnderlineInputBorder(), // Düz çizgi
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white), // Seçildiğinde beyaz çizgi
          ),
        ),
        style: TextStyle(
            color: Colors.white,
            fontSize: 12), // Kullanıcının yazdığı yazı boyutu
      ),
    );
  }
}
