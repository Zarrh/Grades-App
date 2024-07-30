import 'package:flutter/material.dart';
import 'statspage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_math_fork/flutter_math.dart';
import '../constants/colors.dart';
import '../data/grade.dart';
import '../data/grades.dart';
import '../data/subject.dart';
import '../components/custom_box.dart';
import '../components/line_chart_card.dart';
import '../utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Grades _grades = Grades(year: "2023-2024");
  bool _loaded = false;
  List<Subject> _subjects = [];
  List<Widget> _mainContent = [];

  static const excludedSubjects = [
    "Religione Cattolica",
  ];

  getGrades() async {

      const url = "https://drive.google.com/uc?export=download&id=1jC9dm9Klvxds60A82hXmywXMWfFydU3Y";

      var response = await http.get(Uri.parse(url));

      // print(jsonDecode(utf8.decode(response.bodyBytes)));

      // return jsonDecode(utf8.decode(response.bodyBytes));
      _grades.results = jsonDecode(utf8.decode(response.bodyBytes));
  }

  void _updateGrades() {
    // _loaded = false; // Can also be removed
    getGrades().then((_) {
      setState(() {
        _mainContent = [];
        _mainContent.add(const SizedBox(height: 20));
        _subjects = [];

        List<FlSpot> spots = [];

        _grades.results?.forEach((key, subject) {
          List<Grade> marks = [];
          Subject subj = Subject(name: key, color: subjectColors[key]);

          for (final grade in subject) {
            marks.add(Grade(value: double.parse(grade["value"]), weight: percToDouble(grade["weight"]) ?? 1, date: grade["date"]));
          }
          
          subj.grades = marks;

          if (!excludedSubjects.contains(subj.name)) {
            for (final grade in subj.grades) {
              spots.add(FlSpot(dateJanToSep(dateToInt(grade.date ?? "10/09/2024")).toDouble(), grade.value));
            }
          }
          
          _subjects.add(subj);
        });

        List<Grade> allGrades = _subjects
          .where((subject) => !excludedSubjects.contains(subject.name))
          .expand((subject) => subject.grades)
          .toList();
        List<num> values = allGrades.map((g) => g.value).toList();
        List<num> weights = allGrades.map((g) => g.weight).toList();

        dynamic wm = weightedMean(values, weights) ?? "N/D"; // Weighted mean
        dynamic sd = standardDeviation(values) ?? "N/D"; // Standard deviation

        spots.sort((a, b) => a.x.compareTo(b.x));
        _mainContent.add(
          Container(
            padding: const EdgeInsets.all(6),
            child: LineChartCard(
              subject: "All subjects", 
              spots: spots,
              color: primaryColor,
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
                        wm.toStringAsFixed(3),
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
                        sd.toStringAsFixed(3),
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

        spots = [];
        Map<double, double> distribution = {};

        for (final grade in allGrades) {
          if (distribution.containsKey(grade.value)) {
            distribution[grade.value] = distribution[grade.value]! + 1;
            continue;
          }
          distribution[grade.value] = 1;
        }

        for (final mark in distribution.keys) {
          spots.add(FlSpot(mark, distribution[mark] ?? 0));
        }

        spots.sort((a, b) => a.x.compareTo(b.x));
        _mainContent.add(
          Container(
            padding: const EdgeInsets.all(6),
            child: LineChartCard(
              subject: "Grades distribution", 
              spots: spots,
              color: primaryColor,
              bottomCaption: "R10-1",
            ),
          ), 
        );

        _loaded = true;
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StatsPage(title: "Grades statistics", subjects: _subjects),
              ),
            );
          },
          icon: const Icon(
            Icons.bar_chart,
            color: primaryColor,
          ),
        ), 
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: !_loaded 
              ? [
                  const SizedBox(height: 40),
                  const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                ] 
              : _mainContent,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Update",
        backgroundColor: primaryColor,
        onPressed: () => {_updateGrades()},
        child: const Icon(Icons.refresh),
      ),
    );
  }
}