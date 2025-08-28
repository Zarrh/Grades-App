import 'package:flutter/material.dart';
import 'package:grades_app/components/custom_box.dart';
import 'homepage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../data/subject.dart';
import '../constants/colors.dart';
import '../utils/utils.dart';

const List<int> gradesLabel = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10
];

class CalcPage extends StatefulWidget {

  const CalcPage({super.key, this.subjects = const []});

  final List<Subject> subjects;

  @override
  State<CalcPage> createState() => _CalcPageState();
}

class _CalcPageState extends State<CalcPage> {

  Map<dynamic, int?> _marks = {};
  List<Widget> _content = [];
  List<Widget> _boxes = [];

  void setMarks () {
    setState(() {
      _marks = {};
      for (final subj in widget.subjects) {
        if (!HomePage.excludedSubjects.contains(subj.name)) {
          _marks[subj.name] = subj.weightedMean?.round();
        }
      }
      _marks["Comportamento"] = 9;
    });
  }

  @override
  void initState() {
    super.initState();
    setMarks();
  }

  @override
  Widget build(BuildContext context) {
    _content = [];
    _boxes = [];
    _marks.forEach((subj, mark) {
      if (!HomePage.excludedSubjects.contains(subj)) {
        _boxes.add(
          CustomBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 5.0,
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: mark != null ? mark / 10 : 0,
                  // progressColor: primaryColor,
                  backgroundColor: CustomTheme.primaryColor.withOpacity(0.25),
                  // rotateLinearGradient: true,
                  linearGradient: LinearGradient(
                    colors: mark == 10 ? 
                    [
                      topColor,
                      topColor.withOpacity(0.5),
                    ]
                    : [
                      CustomTheme.primaryColor,
                      thirdColor,
                    ],
                  ),
                  center: DropdownButton<int>(
                    value: mark,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: thirdColor),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (int? value) {
                      setState(() {
                        _marks[subj] = value;
                      });
                    },
                    items: gradesLabel.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  )
                ),
                const SizedBox(height: 20),
                subj.length < 20 ? Text(subj, style: TextStyle(color: CustomTheme.primaryColor, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
                : Text(subj.substring(0, 17) + "...", style: TextStyle(color: CustomTheme.primaryColor, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ],
            )
          )
        );
      }
    });

    _content.add(
      GridView.count(
        padding: const EdgeInsets.all(6),
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: _boxes,
      )
    );

    _content.add(const SizedBox(height: 40));
    _content.add(
      Text("Average", style: TextStyle(color: CustomTheme.primaryColor, fontSize: 24, fontWeight: FontWeight.bold))
    );  
    _content.add(const SizedBox(height: 40));

    _content.add(CustomBox(child: Text(mean(_marks.values.toList()).toString(), style: TextStyle(fontSize: 24, color: mean(_marks.values.toList())! > 9 ? topColor : mean(_marks.values.toList())! < 6 ? negativeColor : CustomTheme.primaryColor))));

    _content.add(const SizedBox(height: 40));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _content,
    );
  }
}