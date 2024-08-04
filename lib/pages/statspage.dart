import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../constants/colors.dart';
import '../components/line_chart_card.dart';
import '../components/custom_box.dart';
import '../data/grade.dart';
import '../data/subject.dart';
import '../utils/utils.dart';
import '../pages/subjectpage.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key, required this.title, this.subjects});

  final String title;
  final List<Subject>? subjects;

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  final List<Widget> _mainContent = [];

  void _updateGrades() {
    _mainContent.add(const SizedBox(height: 40));
    setState(() {
      widget.subjects?.forEach((subject) {
        List<FlSpot> spots = [];
        List<Grade> marks = subject.grades;

        for (final grade in marks) {
          spots.add(FlSpot(dateJanToSep(dateToInt(grade.date ?? "10/09/2024")).toDouble(), grade.value));
        }

        spots.sort((a, b) => a.x.compareTo(b.x));
        _mainContent.add(
          Container(
            padding: const EdgeInsets.all(6),
            child: LineChartCard(
              subject: subject.name, 
              spots: spots, 
              color: subject.color,
              bottomCaption: "School_year",
              leftCaption: "R10",
            ),
          ), 
        );
        _mainContent.add(
          GridView.count(
            padding: const EdgeInsets.all(6),
            crossAxisSpacing: 6,
            crossAxisCount: 2,
            childAspectRatio: 1,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              CustomBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      child: Math.tex(
                        r'\overline{v}',
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 50),
                      ),
                    ), 
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        subject.weightedMean?.toStringAsFixed(3) ?? "N/D",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: subject.weightedMean != null ? (subject.weightedMean! >= 9.5 ? topColor : secondaryColor) : secondaryColor,
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              CustomBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      child: Math.tex(
                        r'\sigma',
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 50),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        subject.sd?.toStringAsFixed(3) ?? "N/D",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        _mainContent.add(const SizedBox(height: 10));
        _mainContent.add(
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(right: 6, left: 6, top: 0, bottom: 6),
            child: CustomBox(
              color: primaryColor,
              child: IconButton(
                icon: const Icon(Icons.add), 
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubjectPage(subj: subject),
                    ),
                  );
                },
                tooltip: "More",
              )
            )
          ),
        );      
        _mainContent.add(const SizedBox(height: 20));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _updateGrades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon: const Icon(
            Icons.home,
            color: primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _mainContent,
          ),
        ),
      ),
    );
  }
}