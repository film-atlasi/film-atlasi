import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:film_atlasi/features/movie/models/Movie.dart';
import 'package:film_atlasi/core/utils/helpers.dart';
import 'package:film_atlasi/features/movie/widgets/butonmert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:auto_size_text/auto_size_text.dart'; // AutoSizeText kütüphanesini eklemeyi unutmayın!

class Iletipaylas extends StatefulWidget {
  final Movie movie;
  const Iletipaylas({super.key, required this.movie});

  @override
  State<Iletipaylas> createState() => _IletipaylasState();
}

class _IletipaylasState extends State<Iletipaylas> {
  double _rating = 0.0;
  final TextEditingController _textEditingController = TextEditingController();
  bool? _recommendation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.movie.title,
      //       style: const TextStyle(color: Colors.white)),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildDetaylar(context),
        ),
      ),
    );
  }

  List<Widget> buildDetaylar(BuildContext context) {
    final TextTheme _textTheme = Theme.of(context).textTheme;
    final double screenHeight = MediaQuery.of(context).size.height;

    return [
      if (widget.movie.posterPath.isNotEmpty)
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Image.network(
            'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.error, size: 100, color: Colors.red),
          ),
        ),
      const SizedBox(height: 20),
      Text(
        widget.movie.title,
        style: _textTheme.titleLarge,
      ),
      AddVerticalSpace(context, 0.015),
      Text(
        '10 üzerinden kaç verdiniz?',
        style: _textTheme.bodyMedium,
      ),
      AddVerticalSpace(context, 0.005),
      RatingBar.builder(
        initialRating: _rating,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 9,
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          setState(() {
            _rating = rating;
          });
        },
      ),
      AddVerticalSpace(context, 0.01),
      const Divider(color: const Color.fromARGB(255, 102, 102, 102)),
      AddVerticalSpace(context, 0.01),
      Text(
        'Film hakkındaki düşünceleriniz:',
        style: _textTheme.bodyMedium,
      ),
      AddVerticalSpace(context, 0.01),
      AutoSizeTextField(
        controller: _textEditingController,
        minFontSize: 20,
        maxLines: 7,
        style: const TextStyle(fontSize: 30),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.all(20)),
      ),
      AddVerticalSpace(context, 0.03),
      Text(
        'Filmi tavsiye eder misiniz?',
        style: _textTheme.bodyLarge,
      ),
      const SizedBox(height: 10),
      buildTavsiyeButonlari(),
      const SizedBox(height: 20),
      buildPaylasButton(context),
    ];
  }

  Center buildPaylasButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (_rating > 0 &&
              _textEditingController.text.isNotEmpty &&
              _recommendation != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('İnceleme paylaşıldı!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: const Text('Paylaş'),
      ),
    );
  }

  Widget buildTavsiyeButonlari() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Ortala
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _recommendation == true
                      ? [Colors.green.shade400, Colors.green.shade600]
                      : [Colors.grey.shade300, Colors.grey.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _recommendation = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const AutoSizeText(
                  'Evet',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  maxFontSize: 18, // Maksimum font boyutu
                  minFontSize: 12, // Minimum font boyutu
                  maxLines: 1, // Tek satırda kalsın
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10.0), // Butonlar arası boşluk
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _recommendation == false
                      ? [Colors.red.shade400, Colors.red.shade600]
                      : [Colors.grey.shade300, Colors.grey.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _recommendation = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const AutoSizeText(
                  'Hayır',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxFontSize: 18,
                  minFontSize: 12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
