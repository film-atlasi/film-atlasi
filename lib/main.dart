import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/constants/AppTheme.dart';
import 'package:film_atlasi/core/provider/PageIndexProvider.dart';
import 'package:film_atlasi/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print("Firebas initiali application.");
  } catch (e) {
    print("Hata: $e");
  }

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => PageIndexProvider())],
    child: const Myapp(),
  ));
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: AppTheme.darkTheme, // Karanlık tema
        themeMode: ThemeMode.dark, // Cihazın temasına göre belirler
        theme: AppTheme.darkTheme, // Açık tema
        initialRoute: '/giris',
        routes: AppConstants.routes); //aaaa
  }
}
