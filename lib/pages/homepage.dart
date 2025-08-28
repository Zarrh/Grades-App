import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../constants/colors.dart';
import '../data/grade.dart';
import '../data/global_grades.dart';
import '../data/subject.dart';
import '../data/global_subject.dart';
import '../components/custom_box.dart';
import '../components/line_chart_card.dart';
import '../components/bar_chart_card.dart';
import '../utils/utils.dart';

class HomePage {

  List<Widget> _content = [];
  GlobalGrades _grades = GlobalGrades();
  String? _selectedYear;
  List<FlSpot> _spots = [];
  List<BarChartGroupData> _barSpots = [];

  List<Subject> _subjects = [];
  Map<String, GlobalSubject> _globalSubjects = {};

  static const excludedSubjects = [
    "Religione Cattolica",
  ];

  List<Widget> get content {
    return _content;
  }

  List<Subject> get subjects {
    return _subjects;
  }

  Map<String, GlobalSubject> get globalSubjects {
    return _globalSubjects;
  }

  set setGrades(GlobalGrades grades) {
    _grades = grades;
  }

  set setYear(year) {
    _selectedYear = year;
  }

  void _clear() {
    _spots = [];
    _barSpots = [];
    _subjects = [];
    _globalSubjects = {};
    _content = [];
  }

  void render() {
    _clear();
    _selectedYear ??= _grades.yearlyGrades?.keys.toList().last;

    _content.add(const SizedBox(height: 20));
    _content.add(Text(_selectedYear ?? "", style: TextStyle(color: CustomTheme.secondaryColor, fontSize: 26, fontWeight: FontWeight.w500)));  
    _content.add(const SizedBox(height: 20));

    if (_selectedYear == "All years") {
      if (_grades.yearlyGrades != null) {
        List<num>? values = _grades.yearlyGrades!.values
          .expand((subjects) => subjects.entries)
          .where((entry) => !excludedSubjects.contains(entry.key))
          .expand((entry) => entry.value)
          .map((grade) => double.parse(grade["value"]))
          .toList();

        List<num>? weights = _grades.yearlyGrades!.values
          .expand((subjects) => subjects.entries)
          .where((entry) => !excludedSubjects.contains(entry.key))
          .expand((entry) => entry.value)
          .map((grade) => percToDouble(grade["weight"]) ?? 1)
          .toList();

        dynamic wm = weightedMean(values, weights); // Weighted mean
        dynamic sd = standardDeviation(values); // Standard deviation

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
                    const SizedBox(height: 7),
                    CircularPercentIndicator(
                      radius: 45.0,
                      lineWidth: 5.0,
                      circularStrokeCap: CircularStrokeCap.round,
                      percent: wm != null ? wm / 10 : 0,
                      // progressColor: primaryColor,
                      backgroundColor: CustomTheme.primaryColor.withOpacity(0.25),
                      // rotateLinearGradient: true,
                      linearGradient: LinearGradient(
                        colors: [
                          CustomTheme.primaryColor,
                          thirdColor,
                        ],
                        // stops: [
                        //   0.1,
                        //   0.5,
                        // ],
                      ),
                      center: Text(
                        wm?.toStringAsFixed(3) ?? "N/D",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: wm != null ? (wm.toInt() >= 9 ? topColor : CustomTheme.secondaryColor) : CustomTheme.secondaryColor,
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
                        textStyle: TextStyle(fontWeight: FontWeight.bold, color: CustomTheme.primaryColor, fontSize: 50),
                      ),
                    ),
                    const SizedBox(height: 7),
                    CircularPercentIndicator(
                      radius: 45.0,
                      lineWidth: 5.0,
                      circularStrokeCap: CircularStrokeCap.round,
                      percent: sd != null ? sd / 5 : 0,
                      // progressColor: primaryColor,
                      backgroundColor: CustomTheme.primaryColor.withOpacity(0.25),
                      // rotateLinearGradient: true,
                      linearGradient: LinearGradient(
                        colors: [
                          CustomTheme.primaryColor,
                          thirdColor,
                        ],
                        // stops: [
                        //   0.1,
                        //   0.5,
                        // ],
                      ),
                      center: Text(
                        sd?.toStringAsFixed(3) ?? "N/D",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.secondaryColor,
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
        dynamic distribution = getDistribution(values);

        for (final mark in distribution.keys) {
          _spots.add(FlSpot(mark.toDouble(), distribution[mark] ?? 0));
        }

        _spots.sort((a, b) => a.x.compareTo(b.x));
        _content.add(
          Container(
            padding: const EdgeInsets.all(6),
            child: LineChartCard(
              subject: "Grades distribution", 
              spots: _spots,
              color: CustomTheme.primaryColor,
              bottomCaption: "R10-1",
              isCurved: false,
            ),
          ), 
        );

        _content.add(const SizedBox(height: 20));

        _barSpots = [];
        distribution = getIntegerDistribution(values);

        for (final mark in distribution.keys) {
          _barSpots.add(BarChartGroupData(
              x: mark.toInt(),
              barRods: [
                BarChartRodData(
                  toY: distribution[mark] ?? 0,
                  gradient: LinearGradient(
                    colors: [
                      CustomTheme.selectionColor,
                      CustomTheme.selectionColor.withOpacity(0.5),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                )
              ],
              showingTooltipIndicators: [0],
            ),
          );
        }

        _barSpots.sort((a, b) => a.x.compareTo(b.x));
        _content.add(
          Container(
            padding: const EdgeInsets.all(6),
            child: BarChartCard(
              subject: "Grades distribution", 
              spots: _barSpots,
              color: CustomTheme.primaryColor,
            ),
          ), 
        );

        _content.add(const SizedBox(height: 20));

        _barSpots = [];
        distribution = getClassesDistribution(values);
        final Map<int, String> customCaption = {};

        for (var j = 0; j < distribution.keys.length; j++) {
          _barSpots.add(BarChartGroupData(
              x: j,
              barRods: [
                BarChartRodData(
                  toY: distribution[distribution.keys.elementAt(j)] ?? 0,
                  gradient: LinearGradient(
                    colors: [
                      CustomTheme.selectionColor,
                      CustomTheme.selectionColor.withOpacity(0.5),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                )
              ],
              showingTooltipIndicators: [0],
            ),
          );
          customCaption[j] = "${distribution.keys.elementAt(j).toStringAsFixed(1)}";
        }

        _content.add(
          Container(
            padding: const EdgeInsets.all(6),
            child: BarChartCard(
              subject: "Grades distribution", 
              spots: _barSpots,
              color: CustomTheme.primaryColor,
              customBottomCaption: customCaption,
            ),
          ), 
        );
      }

      _content.add(const SizedBox(height: 70));

      return;
    }

    ////////////////////////////////
    
    _grades.yearlyGrades?.forEach((year, subjects) {
      subjects.forEach((key, subject) {
        final List<Grade> marks = [];
        final Subject subj = Subject(name: key);

        for (final grade in subject) {
          marks.add(Grade(value: double.parse(grade["value"]), weight: percToDouble(grade["weight"]) ?? 1, date: grade["date"]));
        }
        
        subj.grades = marks;
        subj.sd = standardDeviation(subj.grades.map((e) => e.value).toList());
        subj.mean = mean(subj.grades.map((e) => e.value).toList());
        subj.weightedMean = weightedMean((subj.grades.map((e) => e.value).toList()), subj.grades.map((e) => e.weight).toList());
        if (_grades.finalGrades?[year]?[key] != null) {
          subj.finalScore = double.parse(_grades.finalGrades![year]![key]);
        }

        if (_globalSubjects.containsKey(key)) {
          _globalSubjects[key]!.subjects[year] = subj;
        } else {
          _globalSubjects[key] = GlobalSubject(name: key, subjects: {year: subj});
        }
      });
    });

    _grades.yearlyGrades?[_selectedYear]?.forEach((key, subject) {
      final List<Grade> marks = [];
      final Subject subj = Subject(name: key, year: _selectedYear,color: subjectColors[key.toLowerCase()]);

      for (final grade in subject) {
        marks.add(Grade(value: double.parse(grade["value"]), weight: percToDouble(grade["weight"]) ?? 1, date: grade["date"]));
      }
      
      subj.grades = marks;
      subj.sd = standardDeviation(subj.grades.map((e) => e.value).toList());
      subj.mean = mean(subj.grades.map((e) => e.value).toList());
      subj.weightedMean = weightedMean((subj.grades.map((e) => e.value).toList()), subj.grades.map((e) => e.weight).toList());
      if (_grades.finalGrades?[_selectedYear]?[key] != null) {
        subj.finalScore = double.parse(_grades.finalGrades![_selectedYear]![key]);
      }

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
    _content.add(
      Container(
        padding: const EdgeInsets.all(6),
        child: LineChartCard(
          subject: "All subjects", 
          spots: _spots,
          color: CustomTheme.primaryColor,
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
                const SizedBox(height: 7),
                CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 5.0,
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: wm != null ? wm / 10 : 0,
                  // progressColor: primaryColor,
                  backgroundColor: CustomTheme.primaryColor.withOpacity(0.25),
                  // rotateLinearGradient: true,
                  linearGradient: LinearGradient(
                    colors: [
                      CustomTheme.primaryColor,
                      thirdColor,
                    ],
                    // stops: [
                    //   0.1,
                    //   0.5,
                    // ],
                  ),
                  center: Text(
                    wm?.toStringAsFixed(3) ?? "N/D",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: wm != null ? (wm.toInt() >= 9 ? topColor : CustomTheme.secondaryColor) : CustomTheme.secondaryColor,
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
                    textStyle: TextStyle(fontWeight: FontWeight.bold, color: CustomTheme.primaryColor, fontSize: 50),
                  ),
                ),
                const SizedBox(height: 7),
                CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 5.0,
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: sd != null ? sd / 5 : 0,
                  // progressColor: primaryColor,
                  backgroundColor: CustomTheme.primaryColor.withOpacity(0.25),
                  // rotateLinearGradient: true,
                  linearGradient: LinearGradient(
                    colors: [
                      CustomTheme.primaryColor,
                      thirdColor,
                    ],
                    // stops: [
                    //   0.1,
                    //   0.5,
                    // ],
                  ),
                  center: Text(
                    sd?.toStringAsFixed(3) ?? "N/D",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.secondaryColor,
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
    dynamic distribution = getDistribution(values);

    for (final mark in distribution.keys) {
      _spots.add(FlSpot(mark.toDouble(), distribution[mark] ?? 0));
    }

    _spots.sort((a, b) => a.x.compareTo(b.x));
    _content.add(
      Container(
        padding: const EdgeInsets.all(6),
        child: LineChartCard(
          subject: "Grades distribution", 
          spots: _spots,
          color: CustomTheme.primaryColor,
          bottomCaption: "R10-1",
          isCurved: false,
        ),
      ), 
    );

    _content.add(const SizedBox(height: 20));

    _barSpots = [];
    distribution = getIntegerDistribution(values);

    for (final mark in distribution.keys) {
      _barSpots.add(BarChartGroupData(
          x: mark.toInt(),
          barRods: [
            BarChartRodData(
              toY: distribution[mark] ?? 0,
              gradient: LinearGradient(
                colors: [
                  CustomTheme.selectionColor,
                  CustomTheme.selectionColor.withOpacity(0.5),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }

    _barSpots.sort((a, b) => a.x.compareTo(b.x));
    _content.add(
      Container(
        padding: const EdgeInsets.all(6),
        child: BarChartCard(
          subject: "Grades distribution", 
          spots: _barSpots,
          color: CustomTheme.primaryColor,
        ),
      ), 
    );

    _content.add(const SizedBox(height: 20));

    _barSpots = [];
    distribution = getClassesDistribution(values);
    final Map<int, String> customCaption = {};

    if (distribution != {}) {
      for (var j = 0; j < distribution.keys.length; j++) {
        _barSpots.add(BarChartGroupData(
            x: j,
            barRods: [
              BarChartRodData(
                toY: distribution[distribution.keys.elementAt(j)] ?? 0,
                gradient: LinearGradient(
                  colors: [
                    CustomTheme.selectionColor,
                    CustomTheme.selectionColor.withOpacity(0.5),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              )
            ],
            showingTooltipIndicators: [0],
          ),
        );
        customCaption[j] = "${distribution.keys.elementAt(j).toStringAsFixed(1)}";
      }

      _content.add(
        Container(
          padding: const EdgeInsets.all(6),
          child: BarChartCard(
            subject: "Grades distribution", 
            spots: _barSpots,
            color: CustomTheme.primaryColor,
            customBottomCaption: customCaption,
          ),
        ), 
      );
    }

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

    _content.add(
      Container(
        padding: const EdgeInsets.all(6),
        child: LineChartCard(
          subject: "Most constant subject:", 
          subtitle: mostConstantSubj.name,
          latexAction: r'\sigma=' + minSD.toStringAsFixed(3),
          spots: _spots,
          color: mostConstantSubj.color ?? CustomTheme.primaryColor,
          bottomCaption: "School_year",
          leftCaption: "R10",
        ),
      ), 
    );

    _spots = [];
    for (final grade in highestSubj.grades) {
      _spots.add(FlSpot(dateJanToSep(dateToInt(grade.date ?? "10/09/2024")).toDouble(), grade.value));
    }

    _content.add(
      Container(
        padding: const EdgeInsets.all(6),
        child: LineChartCard(
          subject: "Best scored subject:", 
          subtitle: highestSubj.name,
          latexAction: r'\overline{v}=' + maxAVG.toStringAsFixed(3),
          spots: _spots,
          color: highestSubj.color ?? CustomTheme.primaryColor,
          bottomCaption: "School_year",
          leftCaption: "R10",
        ),
      ), 
    );

    if (_grades.finalGrades?[_selectedYear] != {}) {
      List<dynamic> values = _grades.finalGrades![_selectedYear].entries
        .where((entry) => !excludedSubjects.contains(entry.key))
        .map((entry) => double.parse(entry.value.toString()))
        .toList();
      wm = mean(values);
      sd = standardDeviation(values);
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
                  const SizedBox(height: 7),
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 5.0,
                    circularStrokeCap: CircularStrokeCap.round,
                    percent: wm != null ? wm / 10 : 0,
                    // progressColor: primaryColor,
                    backgroundColor: CustomTheme.primaryColor.withOpacity(0.25),
                    // rotateLinearGradient: true,
                    linearGradient: LinearGradient(
                      colors: [
                        CustomTheme.primaryColor,
                        thirdColor,
                      ],
                      // stops: [
                      //   0.1,
                      //   0.5,
                      // ],
                    ),
                    center: Text(
                      wm?.toStringAsFixed(3) ?? "N/D",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: wm != null ? (wm.toInt() >= 9 ? topColor : CustomTheme.secondaryColor) : CustomTheme.secondaryColor,
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
                      textStyle: TextStyle(fontWeight: FontWeight.bold, color: CustomTheme.primaryColor, fontSize: 50),
                    ),
                  ),
                  const SizedBox(height: 7),
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 5.0,
                    circularStrokeCap: CircularStrokeCap.round,
                    percent: sd != null ? sd / 5 : 0,
                    // progressColor: primaryColor,
                    backgroundColor: CustomTheme.primaryColor.withOpacity(0.25),
                    // rotateLinearGradient: true,
                    linearGradient: LinearGradient(
                      colors: [
                        CustomTheme.primaryColor,
                        thirdColor,
                      ],
                      // stops: [
                      //   0.1,
                      //   0.5,
                      // ],
                    ),
                    center: Text(
                      sd?.toStringAsFixed(3) ?? "N/D",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.secondaryColor,
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
    }
  }
}