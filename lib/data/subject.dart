import 'package:flutter/material.dart';
import './grade.dart';

class Subject {
  Subject({required this.name, this.color, this.year, this.grades = const []});

  final String name;
  final String? year;
  final Color? color;
  List<Grade> grades;
  double? sd;
  double? weightedMean;
  double? mean;
  double? finalScore;
}