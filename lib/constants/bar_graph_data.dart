import 'package:fl_chart/fl_chart.dart';

class BarGraphData {

  final List<BarChartGroupData>? spots;
  final String bottomCaption;
  final String leftCaption;

  late final Map<int, String> bottomTitle;
  late final Map<int, String> leftTitle;
  late final double maxY;

  BarGraphData({required this.spots, this.bottomCaption = "", this.leftCaption = ""}) {
    switch (bottomCaption) {
      case 'R10':
        bottomTitle = {
          0: '0',
          2: '2',
          4: '4',
          6: '6',
          8: '8',
          10: '10', 
        };
        break;
      default:
        bottomTitle = {
          0: '0-1',
          1: '1-2',
          2: '2-3',
          3: '3-4',
          4: '4-5',
          5: '5-6',
          6: '6-7',
          7: '7-8',
          8: '8-9',
          9: '9-10',
          10: '10', 
        };
        break;
    }

    switch (leftCaption) {
      case 'R10':
        leftTitle = {
          0: '0',
          2: '2',
          4: '4',
          6: '6',
          8: '8',
          10: '10',
        };
        maxY = 10;
        break;
      default:
        double max = 0;
        if (spots != null) {
          for (final p in spots!) {
            for (final rod in p.barRods) {
              if (rod.toY > max) {
                max = rod.toY;
              }
            }
          }
        }
        
        leftTitle = {};
        for (var i = 0; i < max+4; i+=4) {
          leftTitle[i] = i.toString();
        }
        maxY = max;
    }
  }
}