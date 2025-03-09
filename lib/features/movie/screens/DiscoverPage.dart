import 'package:film_atlasi/features/movie/screens/DİscoveryScreen/DiscoveryPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Durum çubuğunu şeffaf yap
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return const DiscoveryPage();
  }
}
