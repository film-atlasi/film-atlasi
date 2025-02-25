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
    const Icon(Icons.book, color: Colors.white),
    const Text('Filmi Ara ve İncele '),
    const Icon(Icons.edit, color: Colors.white),
    const Text('Oyuncu ve Yönetmen Ara'),
    const Icon(Icons.format_quote, color: Colors.white),
    const Text('Filmden Alıntı Paylaş'),
    const Icon(Icons.message, color: Colors.white),
    const Text('Film Listesi Oluştur'),

    //  const Icon(Icons.track_changes, color: Colors.white),
    //  const Text('İzleme Hedefi'),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.35,
      padding: const EdgeInsets.all(20.0), // Kenar boşlukları için padding
      decoration: const BoxDecoration(
        color: Colors.black, // Arka plan rengi siyah
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
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20), // Başlıkla ikonlar arası boşluk

          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) => ListTile(
                leading: items[2 * index],
                title: items[2 * index + 1],
                onTap: () {
                  String mode = "";

                  switch (index) {
                    case 0:
                      mode = "favorilere_ekle";
                      break;
                    case 1:
                      mode = "oyuncu_yonetmen";
                      break;
                    case 3:
                      mode = "film_listesi";
                      break;
                    case 2:
                      mode = "film_alinti";
                      break;

                    // case 4:
                    //   mode = "izleme_hedefi";
                    //   break;
                  }
                  if (mode == "oyuncu_yonetmen") {
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
