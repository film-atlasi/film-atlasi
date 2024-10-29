import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);
  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 1, 2),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          children: [
            AddVerticalSpace(context, 0.04),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/image2.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            AddVerticalSpace(context, 0.04),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
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
                    ),
                  ),
                  AddVerticalSpace(context, 0.04),
                  TextField(
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: 'Şifre',
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  AddVerticalSpace(context, 0.04),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/anasayfa');
                    },
                    child: const Text('Giriş Yap'),
                  ),
                ],
              ),
            ),
          ],
        ))));
  }
}
