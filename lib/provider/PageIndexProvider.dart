import 'package:flutter/material.dart';

class PageIndexProvider extends ChangeNotifier {
  int _menuIndex = 0;

  int get menuIndex => _menuIndex;

  set menuIndex(int index) {
    _menuIndex = index;
    notifyListeners();
  }
}
