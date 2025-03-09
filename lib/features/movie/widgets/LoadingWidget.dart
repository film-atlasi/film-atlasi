import 'package:film_atlasi/core/provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = Provider.of<ThemeProvider>(context).themeMode;
    return Center(
      child: Lottie.asset(
        themeMode == ThemeMode.dark
            ? 'assets/animations/loading.json'
            : 'assets/animations/loadingLight.json',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}
