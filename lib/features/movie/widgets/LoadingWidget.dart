import 'package:film_atlasi/core/provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoadingWidget extends StatelessWidget {
  final String? url;
  const LoadingWidget({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = Provider.of<ThemeProvider>(context).themeMode;
    return Center(
      child: Lottie.asset(
        url != null
            ? url!
            : themeMode == ThemeMode.dark
                ? 'assets/animations/loading.json'
                : 'assets/animations/loadingLight.json',
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      ),
    );
  }
}
