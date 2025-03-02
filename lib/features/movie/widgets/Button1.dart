import 'package:flutter/material.dart';

ElevatedButton Button1(bool isHovering, BuildContext context, Function cb) =>
    ElevatedButton(
      onPressed: () async {
        await cb();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isHovering
            ? const Color.fromARGB(255, 255, 255, 255)
            : const Color.fromARGB(255, 0, 0,
                0), // Arka plan rengi fare ile üzerine gelindiğinde siyah
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      child: Text(
        'Giriş Yap',
        style: TextStyle(
          color: isHovering
              ? const Color.fromARGB(255, 0, 0, 0)
              : const Color.fromARGB(255, 255, 255,
                  255), // Yazı rengi başlangıçta beyaz, fare ile üzerine gelindiğinde siyah olacak
        ),
      ),
    );
