import 'package:flutter/material.dart';

class FilmEkleWidget extends StatefulWidget {
  @override
  _FilmEkleWidgetState createState() => _FilmEkleWidgetState();
}

class _FilmEkleWidgetState extends State<FilmEkleWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Film Ekle'),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 400,
                child: Center(
                  child: ElevatedButton(
                    child: const Text("Kapat"),
                    onPressed: () {
                      Navigator.pop(context); // Modal kapatma
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
