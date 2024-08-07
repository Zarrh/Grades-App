import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../components/custom_box.dart';
import '../constants/colors.dart';
import '../constants/bar_graph_data.dart';

class _BarChart extends StatelessWidget {
  const _BarChart({required this.data});

  final BarGraphData data;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: data.maxY,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = data.bottomTitle[value.toInt()] ?? "";
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> get barGroups => data.spots ?? [];
}

class BarChartCard extends StatefulWidget {
  const BarChartCard({
    super.key, 
    this.spots, 
    required this.subject, 
    this.subtitle,
    this.latexAction,
    this.color = Colors.blue, 
    this.leftCaption = "",
    this.bottomCaption = "",
  });

  final List<BarChartGroupData>? spots;
  final Color? color;
  final String bottomCaption;
  final String leftCaption;
  final String subject;
  final String? subtitle;
  final String? latexAction;

  @override
  State<BarChartCard> createState() => _BarChartCardState();
}

class _BarChartCardState extends State<BarChartCard> {

  late Color? color;

  @override
  void initState() {
    super.initState();
    color = widget.color ?? Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final data = BarGraphData(
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
            child: _BarChart(data: data),
          ),
        ],
      ),
    );
  }
}