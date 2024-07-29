import 'package:flutter/material.dart';
import './grade.dart';

class Subject {
  Subject({required this.name, this.color, this.grades = const []});

  final String name;
  final Color? color;
  List<Grade> grades;
}