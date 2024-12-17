import 'package:flutter/material.dart';

class AlintiEkle extends StatefulWidget {
  const AlintiEkle({super.key});

  @override
  State<AlintiEkle> createState() => _AlintiEkleState();
}

class _AlintiEkleState extends State<AlintiEkle> {
  final TextEditingController _baslikController = TextEditingController();
  final TextEditingController _alintiController = TextEditingController();
  final TextEditingController _sayfaController = TextEditingController();
  String _konu = 'Film Yorumları';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alıntı Ekle'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Film Poster ve Başlık
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://via.placeholder.com/100x150',
                          height: 100,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      const Expanded(
                        child: Text(
                          'Film İsmi: Örnek Film Adı',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Konu Seçimi
                  const Text(
                    'Konu Seçimi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _konu,
                    isExpanded: true,
                    items: <String>[
                      'Film Yorumları',
                      'Favori Sahneler',
                      'Karakter Alıntıları',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _konu = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Başlık
                  const Text(
                    'Başlık',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _baslikController,
                    maxLength: 65,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Başlık giriniz',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Alıntı Alanı
                  const Text(
                    'Alıntı *',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _alintiController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Alıntınızı buraya yazın...',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sayfa Numarası
                  const Text(
                    'Sayfa',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _sayfaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Alıntı kaçıncı sayfada?',
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Paylaş Butonu
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_baslikController.text.isNotEmpty &&
                            _alintiController.text.isNotEmpty) {
                          setState(() {
                            _isLoading = true;
                          });
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Alıntı başarıyla eklendi!')),
                            );
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Lütfen zorunlu alanları doldurun!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      child: const Text(
                        'Paylaş',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
