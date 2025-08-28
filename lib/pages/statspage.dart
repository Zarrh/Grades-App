import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../constants/colors.dart';
import '../components/line_chart_card.dart';
import '../components/custom_box.dart';
import '../data/grade.dart';
import '../data/subject.dart';
import '../data/global_subject.dart';
import '../utils/utils.dart';
import '../pages/subjectpage.dart';

class StatsPage {

  List<Widget> _content = [];
  List<Subject> _subjects = [];
  Map<String, GlobalSubject> _globalSubjects = {};

  List<Widget> get content {
    return _content;
  }

  set setSubjects(subjects) {
    _subjects = subjects;
  }

  set setGlobalSubjects(globalSubjects) {
    _globalSubjects = globalSubjects;
  }

  void _clear() {
    _content = [];
  }

  void render(context) {
    _clear();
    _content.add(const SizedBox(height: 40));
    for (final subject in _subjects) {
      List<FlSpot> spots = [];
      List<Grade> marks = subject.grades;

      for (final grade in marks) {
        spots.add(FlSpot(dateJanToSep(dateToInt(grade.date ?? "10/09/2024")).toDouble(), grade.value));
      }

      spots.sort((a, b) => a.x.compareTo(b.x));
      _content.add(
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
      _content.add(
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
                      textStyle: TextStyle(fontWeight: FontWeight.bold, color: CustomTheme.primaryColor, fontSize: 50),
                    ),
                  ), 
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      subject.weightedMean?.toStringAsFixed(3) ?? "N/D",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: subject.weightedMean != null ? (subject.weightedMean! >= 9.5 ? topColor : CustomTheme.secondaryColor) : CustomTheme.secondaryColor,
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
                      textStyle: TextStyle(fontWeight: FontWeight.bold, color: CustomTheme.primaryColor, fontSize: 50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      subject.sd?.toStringAsFixed(3) ?? "N/D",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.secondaryColor,
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
      _content.add(const SizedBox(height: 10));
      _content.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(right: 6, left: 6, top: 0, bottom: 6),
          child: CustomBox(
            color: CustomTheme.primaryColor,
            child: IconButton(
              icon: const Icon(Icons.add), 
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectPage(subj: subject, globalSubj: _globalSubjects[subject.name]),
                  ),
                );
              },
              tooltip: "More",
            )
          )
        ),
      );      
      _content.add(const SizedBox(height: 20));
    }
  }
}