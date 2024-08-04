import 'package:flutter/material.dart';
import 'statspage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../constants/colors.dart';
import '../data/grade.dart';
import '../data/global_grades.dart';
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

  List<String> _years = [];
  List<FlSpot> _spots = [];
  String? _selectedYear;
  final GlobalGrades _grades = GlobalGrades();
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
      _grades.yearlyGrades = jsonDecode(utf8.decode(response.bodyBytes));
  }

  void _clear() {
    setState(() {
      _spots = [];
      _years = [];
      _subjects = [];
      _mainContent = [];
      _loaded = false;
    });
  }

  void _setYears() {
    setState(() {
      _grades.yearlyGrades?.forEach((key, value) {
        _years.add(key);
      });
    });
  }

  void _render() {
    setState(() {
      _clear();
      _mainContent = [];
      _selectedYear ??= _grades.yearlyGrades?.keys.toList().last;

      _mainContent.add(const SizedBox(height: 20));
      _setYears();

      _grades.yearlyGrades?[_selectedYear]?.forEach((key, subject) {
        final List<Grade> marks = [];
        final Subject subj = Subject(name: key, color: subjectColors[key]);

        for (final grade in subject) {
          marks.add(Grade(value: double.parse(grade["value"]), weight: percToDouble(grade["weight"]) ?? 1, date: grade["date"]));
        }
        
        subj.grades = marks;
        subj.sd = standardDeviation(subj.grades.map((e) => e.value).toList());
        subj.mean = mean(subj.grades.map((e) => e.value).toList());
        subj.weightedMean = weightedMean((subj.grades.map((e) => e.value).toList()), subj.grades.map((e) => e.weight).toList());

        if (!excludedSubjects.contains(subj.name)) {
          for (final grade in subj.grades) {
            _spots.add(FlSpot(dateJanToSep(dateToInt(grade.date ?? "10/09/2024")).toDouble(), grade.value));
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

      dynamic wm = weightedMean(values, weights); // Weighted mean
      dynamic sd = standardDeviation(values); // Standard deviation

      _spots.sort((a, b) => a.x.compareTo(b.x));
      _mainContent.add(
        Container(
          padding: const EdgeInsets.all(6),
          child: LineChartCard(
            subject: "All subjects", 
            spots: _spots,
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
                  const SizedBox(height: 7),
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 5.0,
                    circularStrokeCap: CircularStrokeCap.round,
                    percent: wm / 10 ?? 0,
                    // progressColor: primaryColor,
                    backgroundColor: primaryColor.withOpacity(0.25),
                    // rotateLinearGradient: true,
                    linearGradient: const LinearGradient(
                      colors: [
                        primaryColor,
                        thirdColor,
                      ],
                      // stops: [
                      //   0.1,
                      //   0.5,
                      // ],
                    ),
                    center: Text(
                      wm.toStringAsFixed(3) ?? "N/D",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: wm != null ? (wm >= 9 ? topColor : secondaryColor) : secondaryColor,
                        fontSize: 24,
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
                  const SizedBox(height: 7),
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 5.0,
                    circularStrokeCap: CircularStrokeCap.round,
                    percent: sd / 5 ?? 0,
                    // progressColor: primaryColor,
                    backgroundColor: primaryColor.withOpacity(0.25),
                    // rotateLinearGradient: true,
                    linearGradient: const LinearGradient(
                      colors: [
                        primaryColor,
                        thirdColor,
                      ],
                      // stops: [
                      //   0.1,
                      //   0.5,
                      // ],
                    ),
                    center: Text(
                      sd.toStringAsFixed(3) ?? "N/D",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                        fontSize: 24,
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

      _spots = [];
      Map<double, double> distribution = {};

      for (final grade in allGrades) {
        if (distribution.containsKey(grade.value)) {
          distribution[grade.value] = distribution[grade.value]! + 1;
          continue;
        }
        distribution[grade.value] = 1;
      }

      for (final mark in distribution.keys) {
        _spots.add(FlSpot(mark, distribution[mark] ?? 0));
      }

      _spots.sort((a, b) => a.x.compareTo(b.x));
      _mainContent.add(
        Container(
          padding: const EdgeInsets.all(6),
          child: LineChartCard(
            subject: "Grades distribution", 
            spots: _spots,
            color: primaryColor,
            bottomCaption: "R10-1",
          ),
        ), 
      );

      double minSD = double.infinity;
      Subject mostConstantSubj = Subject(name: "N/D");
      double maxAVG = 0;
      Subject highestSubj = Subject(name: "N/D");
      for (final subj in _subjects) {
        if (subj.sd != null && subj.sd! < minSD) {
          minSD = subj.sd!;
          mostConstantSubj = subj;
        }
        if (subj.mean != null && subj.mean! > maxAVG) {
          maxAVG = subj.mean!;
          highestSubj = subj;
        }
      }

      _spots = [];
      for (final grade in mostConstantSubj.grades) {
        _spots.add(FlSpot(dateJanToSep(dateToInt(grade.date ?? "10/09/2024")).toDouble(), grade.value));
      }

      _mainContent.add(
        Container(
          padding: const EdgeInsets.all(6),
          child: LineChartCard(
            subject: "Most constant subject:", 
            subtitle: mostConstantSubj.name,
            latexAction: r'\sigma=' + minSD.toStringAsFixed(3),
            spots: _spots,
            color: mostConstantSubj.color ?? primaryColor,
            bottomCaption: "School_year",
            leftCaption: "R10",
          ),
        ), 
      );

      _spots = [];
      for (final grade in highestSubj.grades) {
        _spots.add(FlSpot(dateJanToSep(dateToInt(grade.date ?? "10/09/2024")).toDouble(), grade.value));
      }

      _mainContent.add(
        Container(
          padding: const EdgeInsets.all(6),
          child: LineChartCard(
            subject: "Best scored subject:", 
            subtitle: highestSubj.name,
            latexAction: r'\overline{v}=' + maxAVG.toStringAsFixed(3),
            spots: _spots,
            color: highestSubj.color ?? primaryColor,
            bottomCaption: "School_year",
            leftCaption: "R10",
          ),
        ), 
      );

      _loaded = true;
    });
  }

  void _updateYear(String year) {
    setState(() {
      _selectedYear = year;
    });
  }

  void _updateGrades() {
    getGrades().then((_) {
      setState(() {
        _render();
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
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              _updateYear(value);
              _clear();
              _updateGrades(); // To substitute with _render()
            },
            itemBuilder: (context) => _years.map((year) {
              return PopupMenuItem<String>(
                value: year,
                child: Text(year, style: const TextStyle(color: primaryColor)),
              );
            }).toList(),
            color: backgroundColor,
            iconColor: primaryColor,
          )
        ], 
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
        onPressed: () {
          _clear();
          _updateGrades();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}