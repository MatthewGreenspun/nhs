import 'package:flutter/material.dart';

class IncDecController extends ChangeNotifier {
  int value = 0;

  IncDecController({int? initialValue}) : value = initialValue ?? 0;

  void setValue(int newValue) {
    value = newValue;
    notifyListeners();
  }

  void increment() {
    setValue(value + 1);
  }

  void decrement() {
    setValue(value - 1);
  }
}
