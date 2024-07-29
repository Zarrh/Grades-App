import 'package:flutter/material.dart';

class SharedData with ChangeNotifier {
  double _meanValue = 0.0;

  double get meanValue => _meanValue;

  void updateMeanValue(double value) {
    _meanValue = value;
    notifyListeners();
  }
}