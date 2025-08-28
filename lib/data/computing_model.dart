import '../data/subject.dart';
import '../data/global_subject.dart';

import 'dart:math';

class ComputingModel {

  ComputingModel({required this.subj, this.globalSubj});

  final Subject subj;
  final GlobalSubject? globalSubj;

  num? _v;
  num? _trust = 0;

  num? get v {
    return _v;
  }

  num? get trust {
    return _trust;
  }

  void alpha () {
    _v = subj.weightedMean?.round();
    if (subj.weightedMean != null) {
      _trust = 1.0 - (subj.weightedMean! - subj.weightedMean!.round()).abs();   
      return;
    }
    _trust = 0;
  }

  void beta () {
    if (globalSubj == null) {
      alpha();
      return;
    }

    final years = globalSubj!.subjects.keys.toList();
    num bias = 0;

    for (final year in years) {
      if (year == subj.year || subj.finalScore == null) {
        _v = min(max((subj.weightedMean! + bias).round(), 1), 10);
        _trust = min(max(1.0 - (subj.weightedMean! + bias - _v!).abs(), 0), 1);
        return;
      }
      if (subj.weightedMean?.round() != subj.finalScore) {
        bias += (-subj.weightedMean! + subj.finalScore!) / 2;
      }
    }
  }
}