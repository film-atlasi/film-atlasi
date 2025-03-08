import 'package:film_atlasi/app.dart';
import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/constants/AppTheme.dart';
import 'package:film_atlasi/core/provider/PageIndexProvider.dart';
import 'package:film_atlasi/core/provider/ThemeProvider.dart';
import 'package:film_atlasi/features/user/screens/loginpage.dart';
import 'package:film_atlasi/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    providers: [
      ChangeNotifierProvider(create: (_) => PageIndexProvider()),
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      )
    ],
    child: const Myapp(),
  ));
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context).themeMode;
    final AppConstants appConstants = AppConstants(context);
    final AppTheme appTheme = AppTheme(appConstants);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme.lightTheme,
        darkTheme: appTheme.darkTheme,
        themeMode: themeProvider, // Cihazın temasına uyar
        initialRoute: '/giris',
        routes: AppConstants.routes); //aaaa
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // 🔄 Yüklenme animasyonu
        }
        if (snapshot.hasData) {
          return FilmAtlasiApp(); // ✅ Kullanıcı giriş yaptıysa ana sayfaya yönlendir
        } else {
          return const LoginPage(); // ❌ Kullanıcı giriş yapmamışsa giriş sayfasına yönlendir
        }
      },
    );
  }
}
