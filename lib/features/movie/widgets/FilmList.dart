import 'package:flutter/material.dart';

class FilmList extends StatefulWidget {
  @override
  _FilmListState createState() => _FilmListState();
}

class _FilmListState extends State<FilmList> {
  final List<String> _films = [];
  final TextEditingController _controller = TextEditingController();

  void _addFilm() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _films.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film Listesi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Film Adı',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addFilm,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _films.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_films[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}