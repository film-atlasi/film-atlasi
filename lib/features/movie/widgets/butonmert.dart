import 'package:flutter/material.dart';

class ButtonMert extends StatelessWidget {
  final Color? color;
  final String? text;
  const ButtonMert({super.key, this.color, this.text, });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => null,
        child: Text(text ?? "varsayılan göt"),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(color ?? Colors.blue),
        ));
  }
}
