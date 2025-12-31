import 'package:flutter/material.dart';

class RoutesProvider extends ChangeNotifier {
  String _selected = "word";

  String get selected => _selected;

  void changeTo(String key) {
    _selected = key;
    notifyListeners();
  }
}
