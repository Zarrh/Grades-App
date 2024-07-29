import 'package:fl_chart/fl_chart.dart';

class GraphData {

  final List<FlSpot>? spots;
  final bool isSchoolYear;

  final leftTitle = const {
    0: '0',
    2: '2',
    4: '4',
    6: '6',
    8: '8',
    10: '10',
  };

  late final Map<int, String> bottomTitle;

  GraphData({required this.spots, this.isSchoolYear = true})
    : bottomTitle = !isSchoolYear
      ? {
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
        }
      : {
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
}