import 'package:film_atlasi/features/movie/providers/DiscoverProvider.dart';
import 'package:film_atlasi/features/movie/widgets/FilmAra.dart';
import 'package:film_atlasi/features/movie/widgets/Kesfet/KesfetWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Durum çubuğunu şeffaf yap
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return ChangeNotifierProvider(
      create: (context) => DiscoverProvider(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Film Atlası",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 26),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const FilmAraWidget(mode: "film_incele")),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0A0118),
                Color(0xFF1A0E33),
              ],
            ),
          ),
          child: KesfetWidget(),
        ),
      ),
    );
  }
}
