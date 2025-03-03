import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/user/screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore için gerekli
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late String email;
  late String userName;
  late String name;
  late String password;

  final GlobalKey<FormState> formkey =
      GlobalKey<FormState>(); //form key oluşturuldu

  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore
      .instance; //kullanıcı verileri için firestore oluşturuldu

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 1, 2),
      appBar: AppBar(
        title: Text('Kayıt Ol'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // 🔙 Geri butonu
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Loginpage()),
            ); // Login page'e geri dön
          },
        ),
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
                      controller: _firstNameController,
                      decoration: InputDecoration(labelText: 'isim soyisim'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'isim soyisim giriniz';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userName = value!;
                      }),
                  AddVerticalSpace(context, 0.02),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _userNameController,
                    decoration: InputDecoration(labelText: 'Kullanıcı adı'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'kullanıcı adı giriniz';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userName = value!;
                    },
                  ),
                 
                 
                 
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

                            // Kullanıcı bilgilerini Firestore'a kaydet
                            await firebaseFirestore
                                .collection('users')
                                .doc(userResult.user!.uid)
                                .set({
                              'email': email,
                              'userName': _userNameController.text,
                              'firstName': _firstNameController.text,
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                            print("User data saved to Firestore successfully");

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
                      child: Text(
                        'Kaydol',
                        style: TextStyle(
                          color: _isHovering
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : const Color.fromARGB(255, 255, 255, 255),
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
    return SizedBox(
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
