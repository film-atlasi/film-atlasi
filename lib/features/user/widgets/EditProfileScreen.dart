import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String userId;

  const EditProfilePage({super.key, required this.userMap, required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late TextEditingController _emailController;
  late TextEditingController _userNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _passwordController;

  bool _isLoading = true;
  bool _passwordChanged = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    var userData = widget.userMap;
    _emailController = TextEditingController(text: userData['email']);
    _userNameController = TextEditingController(text: userData['userName']);
    _firstNameController = TextEditingController(text: userData['firstName']);
    _passwordController = TextEditingController();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateUserProfile() async {
  if (_formKey.currentState!.validate()) {
    try {
      await _firestore.collection('users').doc(widget.userId).update({
        'email': _emailController.text.trim(),
        'userName': _userNameController.text.trim(),
        'firstName': _firstNameController.text.trim(),
      });

      // 🔥 Eğer şifre değiştiyse, şifreyi güncelle ve çıkış yap
      if (_passwordChanged) {
        await _auth.currentUser!.updatePassword(_passwordController.text.trim());

        // Kullanıcıyı çıkış yapmaya zorla
        await FirebaseAuth.instance.signOut();

        // Kullanıcıyı giriş ekranına yönlendir
        Navigator.pushNamedAndRemoveUntil(context, '/giris', (route) => false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Şifreniz değiştirildi. Lütfen tekrar giriş yapın.")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil başarıyla güncellendi!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profili Düzenle"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) {
                        if (value!.isEmpty) return "Email boş olamaz";
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _userNameController,
                      decoration: const InputDecoration(labelText: "Kullanıcı Adı"),
                      validator: (value) {
                        if (value!.isEmpty) return "Kullanıcı adı boş olamaz";
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: "İsim Soyisim"),
                      validator: (value) {
                        if (value!.isEmpty) return "İsim boş olamaz";
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: "Yeni Şifre"),
                      obscureText: true,
                      onChanged: (value) {
                        _passwordChanged = value.isNotEmpty;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateUserProfile,
                      child: const Text("Güncelle"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}