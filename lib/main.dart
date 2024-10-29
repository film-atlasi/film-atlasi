import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:film_atlasi/core/constants/AppTheme.dart';
import 'package:film_atlasi/core/provider/PageIndexProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PageIndexProvider())],
      child: const Myapp(),
    ));

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: AppTheme.darkTheme,
        initialRoute: '/',
        routes: AppConstants.routes);
  }
}
