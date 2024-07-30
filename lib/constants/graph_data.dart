import 'package:fl_chart/fl_chart.dart';

class GraphData {

  final List<FlSpot>? spots;
  final bool isSchoolYear;
  final String bottomCaption;
  final String leftCaption;

  late final Map<int, String> bottomTitle;
  late final Map<int, String> leftTitle;
  late final double maxX;
  late final double maxY;

  GraphData({required this.spots, this.isSchoolYear = true, this.bottomCaption = "", this.leftCaption = ""}) {
    switch (bottomCaption) {
      case 'School_year':
        bottomTitle = {
          0: 'Sep',
          30: 'Oct',
          61: 'Nov',
          91: 'Dec',
          122: 'Jan',
          153: 'Feb',
          181: 'Mar',
          212: 'Apr',
          242: 'May',
          273: 'Jun',
        };
        maxX = 303;
        break;
      case 'R10':
        bottomTitle = {
          0: '0',
          2: '2',
          4: '4',
          6: '6',
          8: '8',
          10: '10', 
        };
        maxX = 11;
        break;
      case 'R10-1':
        bottomTitle = {
          0: '0',
          1: '1',
          2: '2',
          3: '3',
          4: '4',
          5: '5',
          6: '6',
          7: '7',
          8: '8',
          9: '9',
          10: '10', 
        };
        maxX = 11;
        break;
      default:
        bottomTitle = {
          0: 'Jan',
          31: 'Feb',
          59: 'Mar',
          90: 'Apr',
          120: 'May',
          151: 'Jun',
          181: 'Jul',
          212: 'Aug',
          243: 'Sep',
          273: 'Oct',
          304: 'Nov',
          334: 'Dec',
        };
        maxX = 365;
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
            if (p.y > max) {
              max = p.y;
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