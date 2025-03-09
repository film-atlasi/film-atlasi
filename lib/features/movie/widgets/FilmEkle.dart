import 'package:film_atlasi/features/movie/screens/FilmListScreen.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:film_atlasi/features/movie/widgets/oyuncu_yonetmen_ara_widget.dart';
import 'package:flutter/material.dart';

class FilmEkleWidget extends StatefulWidget {
  const FilmEkleWidget({super.key});

  @override
  _FilmEkleWidgetState createState() => _FilmEkleWidgetState();
}

class _FilmEkleWidgetState extends State<FilmEkleWidget> {
  final List<dynamic> items = [
    const Icon(Icons.book),
    const Text('Filmi Ara ve İncele '),
    const Icon(Icons.edit),
    const Text('Oyuncu ve Yönetmen Ara'),
    const Icon(Icons.format_quote),
    const Text('Filmden Alıntı Paylaş'),
    const Icon(Icons.message),
    const Text('Film Listesi Oluştur'),

    //  const Icon(Icons.track_changes, color: Colors.white),
    //  const Text('İzleme Hedefi'),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final AppConstants appConstants = AppConstants(context);

    return Container(
      height: screenHeight * 0.35,
      padding: const EdgeInsets.all(20.0), // Kenar boşlukları için padding
      decoration: BoxDecoration(
        color: appConstants.appBarColor, // Arka plan rengi siyah
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Sola hizalı
        children: [
          const Text(
            'Yeni Film Ekleyin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20), // Başlıkla ikonlar arası boşluk

          Expanded(
              child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => ListTile(
              leading: items[2 * index],
              title: items[2 * index + 1],
              onTap: () {
                switch (index) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FilmAraWidget()),
                    );
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AlintiEkle(
                                movieId: 223,
                              )),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OyuncuYonetmenAraWidget(
                            mode: "oyuncu_yonetmen"),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilmAraWidget(mode: mode),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
