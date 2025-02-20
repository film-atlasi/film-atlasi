import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController userNameController;
  late TextEditingController jobController;
  late TextEditingController cityController;

  @override
  void initState() {
    super.initState();
    firstNameController =
        TextEditingController(text: widget.userData['firstName']);
    lastNameController =
        TextEditingController(text: widget.userData['lastName']);
    userNameController =
        TextEditingController(text: widget.userData['userName']);
    jobController = TextEditingController(text: widget.userData['job']);
    cityController = TextEditingController(text: widget.userData['city']);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    jobController.dispose();
    cityController.dispose();
    super.dispose();
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userData['uid'])
            .update({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'userName': userNameController.text,
          'job': jobController.text,
          'city': cityController.text,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil başarıyla güncellendi!")),
        );
        Navigator.pop(context); // Güncellemeden sonra geri dön
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
      appBar: AppBar(title: const Text("Profili Düzenle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: "Ad"),
                validator: (value) =>
                    value!.isEmpty ? "Bu alan boş bırakılamaz" : null,
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: "Soyad"),
              ),
              TextFormField(
                controller: userNameController,
                decoration: InputDecoration(labelText: "Kullanıcı Adı"),
                validator: (value) =>
                    value!.isEmpty ? "Bu alan boş bırakılamaz" : null,
              ),
              TextFormField(
                controller: jobController,
                decoration: InputDecoration(labelText: "Meslek"),
              ),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: "Şehir"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserData,
                child: const Text("Güncelle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
