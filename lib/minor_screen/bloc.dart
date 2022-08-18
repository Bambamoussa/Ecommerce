import 'package:flutter/material.dart';

class Bloc with ChangeNotifier {
  bool folo = false;
  void follow() {
    folo = !folo;
    notifyListeners();
  }
}
