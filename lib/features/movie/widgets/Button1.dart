import 'package:flutter/material.dart';

ElevatedButton Button1(bool _isHovering, BuildContext context, Function cb) =>
    ElevatedButton(
      onPressed: () async {
        await cb();
      },
      child: Text(
        'Giriş Yap',
        style: TextStyle(
          color: _isHovering
              ? const Color.fromARGB(255, 0, 0, 0)
              : const Color.fromARGB(255, 255, 255,
                  255), // Yazı rengi başlangıçta beyaz, fare ile üzerine gelindiğinde siyah olacak
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isHovering
            ? const Color.fromARGB(255, 255, 255, 255)
            : const Color.fromARGB(255, 0, 0,
                0), // Arka plan rengi fare ile üzerine gelindiğinde siyah
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
