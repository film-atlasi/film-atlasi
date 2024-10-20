import 'package:film_atlasi/constants/AppConstants.dart';
import 'package:film_atlasi/constants/AppTheme.dart';
import 'package:flutter/material.dart';

void main() => runApp(const Myapp());

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
