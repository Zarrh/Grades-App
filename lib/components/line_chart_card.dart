import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../components/custom_box.dart';
import '../constants/colors.dart';
import '../constants/graph_data.dart';

class LineChartCard extends StatefulWidget {
  const LineChartCard({
    super.key, 
    this.spots, 
    required this.subject, 
    this.subtitle,
    this.latexAction,
    this.color = Colors.blue, 
    this.leftCaption = "",
    this.bottomCaption = "",
  });

  final List<FlSpot>? spots;
  final Color? color;
  final String bottomCaption;
  final String leftCaption;
  final String subject;
  final String? subtitle;
  final String? latexAction;

  @override
  State<LineChartCard> createState() => _LineChartCardState();
}

class _LineChartCardState extends State<LineChartCard> {

  late Color? color;

  @override
  void initState() {
    super.initState();
    color = widget.color ?? Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final data = GraphData(
      spots: widget.spots,
      bottomCaption: widget.bottomCaption,
      leftCaption: widget.leftCaption,
    );
    return CustomBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.subject,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: primaryColor),
          ),
          GridView.count(
            shrinkWrap: true,
            childAspectRatio: 16 / 5,
            physics: const ScrollPhysics(),
            crossAxisCount: 2,
            children: <Widget>[
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: Text(widget.subtitle ?? "", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: secondaryColor))
              ),
              Container(
                alignment: AlignmentDirectional.centerEnd,
                child: Math.tex(
                  widget.latexAction ?? r"",
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: secondaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(
                  handleBuiltInTouches: true,
                ),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return data.bottomTitle[value.toInt()] != null
                            ? SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                    data.bottomTitle[value.toInt()].toString(),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[400])),
                              )
                            : const SizedBox();
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return data.leftTitle[value.toInt()] != null
                            ? Text(data.leftTitle[value.toInt()].toString(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[400]))
                            : const SizedBox();
                      },
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    color: color,
                    barWidth: 2.5,
                    isCurved: true,
                    belowBarData: BarAreaData(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          color!.withOpacity(0.5),
                          Colors.transparent
                        ],
                      ),
                      show: true,
                    ),
                    dotData: const FlDotData(show: true),
                    spots: data.spots ?? [],
                  )
                ],
                minX: 0,
                maxX: data.maxX,
                maxY: data.maxY,
                minY: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}