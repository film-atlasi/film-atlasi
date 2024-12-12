import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/user/screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late String email;
  late String userName;
  late String name;
  late String surName;
  late String userJob;
  late int age;
  late String password;
  final GlobalKey<FormState> formkey =
      GlobalKey<FormState>(); //form key oluşturuldu
  final firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized successfully in SignUpPage');
    } catch (e) {
      print('Error initializing Firebase in SignUpPage: $e');
    }
  }

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
            //form a alındı
            child: Form(
              key: formkey,
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
                  ),
                  AddVerticalSpace(context, 0.1),
                  Text(
                    'Film Atlası\'na Hoşgeldiniz',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  AddVerticalSpace(context, 0.02),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
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
                  AddVerticalSpace(context, 0.02),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _userNameController,
                    decoration: InputDecoration(labelText: 'Kullanıcı adı'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Bilgileri eksiksiz girininz';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userName = value!;
                    },
                  ),
                  AddVerticalSpace(context, 0.01),
                  _buildTextField('isim', _firstNameController),
                  AddVerticalSpace(context, 0.01),
                  _buildTextField('Şehir', _cityController),
                  AddVerticalSpace(context, 0.01),
                  _buildTextField('Yaş', _ageController),
                  AddVerticalSpace(context, 0.01),
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

                    //mail dogrrulama işlemi
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          formkey.currentState!.save();
                          try {
                            var userResult = await firebaseAuth
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                            print(userResult.user!.uid);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Loginpage()),
                            );
                          } catch (e) {
                            print('Error: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Registration failed: $e'),
                              ),
                            );
                          }
                        }
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
                          side: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller,
      {bool obscureText = false}) {
    return Container(
      width: double.infinity,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white, fontSize: 12),
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
