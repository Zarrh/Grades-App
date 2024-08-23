import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../constants/colors.dart';
import '../data/subject.dart';
import '../components/custom_box.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key, required this.subj});

  final Subject subj;

  @override
  Widget build(BuildContext context) {

    final List<Widget> content = [];
    content.add(const SizedBox(height: 40));

    content.add(
      Container(
        width: double.infinity,
        margin: const EdgeInsets.all(12),
        child: GridView.count(
          shrinkWrap: true,
          childAspectRatio: 16 / 5,
          physics: const ScrollPhysics(),
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: const Text("Score", style: TextStyle(color: primaryColor, fontSize: 26, fontWeight: FontWeight.bold))
            ),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              child: const Text("Date", style: TextStyle(color: primaryColor, fontSize: 26, fontWeight: FontWeight.bold))
            ),
          ],
        )
      ) 
    );      

    for (final grade in subj.grades) {
      content.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(6),
          child: CustomBox(
            child: GridView.count(
              shrinkWrap: true,
              childAspectRatio: 16 / 5,
              physics: const ScrollPhysics(),
              crossAxisCount: 2,
              children: <Widget>[
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(grade.value.toString(), style: TextStyle(color: grade.value >= 9.75 ? topColor : (grade.value >= 5.75 ? positiveColor : negativeColor), fontSize: 24))
                ),
                Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(grade.date.toString(), style: const TextStyle(color: secondaryColor, fontSize: 24))
                ),
              ],
            )
          ) 
        )        
      );
    }

    content.add(const SizedBox(height: 40));

    content.add(
      const Text("Predictions", style: TextStyle(color: primaryColor, fontSize: 26, fontWeight: FontWeight.w500))
    );

    content.add(const SizedBox(height: 20));

    double? trust;
    if (subj.weightedMean != null) {
      trust = 1.0 - (subj.weightedMean! - subj.weightedMean!.round()).abs();
    }

    content.add(
      CustomBox(
        child: GridView.count(
          shrinkWrap: true,
          childAspectRatio: 16 / 11,
          physics: const ScrollPhysics(),
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              alignment: AlignmentDirectional.center,
              margin: const EdgeInsets.only(right: 20),
              child: const Text("Grade", style: TextStyle(color: secondaryColor, fontSize: 26, fontWeight: FontWeight.w500)),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              margin: const EdgeInsets.only(left: 20),
              child: const Text("Trust", style: TextStyle(color: secondaryColor, fontSize: 26, fontWeight: FontWeight.w500)),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              margin: const EdgeInsets.only(right: 20),
              child: CircularPercentIndicator(
                radius: 45.0,
                lineWidth: 5.0,
                circularStrokeCap: CircularStrokeCap.round,
                percent: (subj.weightedMean?.round().toDouble() ?? 0) / 10,
                // progressColor: primaryColor,
                backgroundColor: primaryColor.withOpacity(0.25),
                // rotateLinearGradient: true,
                linearGradient: LinearGradient(
                  colors: subj.weightedMean?.round() == 10 
                  ? 
                  [
                    topColor,
                    topColor.withOpacity(0.5),
                  ] 
                  : 
                  [
                    primaryColor,
                    thirdColor,
                  ]
                  // stops: [
                  //   0.1,
                  //   0.5,
                  // ],
                ),
                center: Text(
                  subj.weightedMean?.round().toString() ?? "N/D",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: subj.weightedMean?.round() != null ? (subj.weightedMean?.round() == 10 ? topColor : secondaryColor) : secondaryColor,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              margin: const EdgeInsets.only(left: 20),
              child: CircularPercentIndicator(
                radius: 45.0,
                lineWidth: 5.0,
                circularStrokeCap: CircularStrokeCap.round,
                percent: (trust ?? 0),
                // progressColor: primaryColor,
                backgroundColor: primaryColor.withOpacity(0.25),
                // rotateLinearGradient: true,
                linearGradient: LinearGradient(
                  colors: trust == 1 
                  ? 
                  [
                    topColor,
                    topColor.withOpacity(0.5),
                  ] 
                  : 
                  [
                    primaryColor,
                    thirdColor,
                  ]
                  // stops: [
                  //   0.1,
                  //   0.5,
                  // ],
                ),
                center: Text(
                  trust?.toStringAsFixed(3) ?? "N/D",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: trust == 1 ? topColor : secondaryColor,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        )
      )
    );

    content.add(const SizedBox(height: 40));

    content.add(
      const Text("Results", style: TextStyle(color: primaryColor, fontSize: 26, fontWeight: FontWeight.w500))
    );

    content.add(const SizedBox(height: 20));

    if (subj.finalScore != null) {
      content.add(
        CustomBox(
          child: GridView.count(
            shrinkWrap: true,
            childAspectRatio: 16 / 11,
            physics: const ScrollPhysics(),
            crossAxisCount: 2,
            children: <Widget>[
              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(right: 20),
                child: const Text("Grade", style: TextStyle(color: secondaryColor, fontSize: 26, fontWeight: FontWeight.w500)),
              ),
              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(left: 20),
                child: const Text("Accuracy", style: TextStyle(color: secondaryColor, fontSize: 26, fontWeight: FontWeight.w500)),
              ),
              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(right: 20),
                child: CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 5.0,
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: (subj.finalScore?.round().toDouble() ?? 0) / 10,
                  // progressColor: primaryColor,
                  backgroundColor: primaryColor.withOpacity(0.25),
                  // rotateLinearGradient: true,
                  linearGradient: LinearGradient(
                    colors: subj.finalScore?.round() == 10 
                    ? 
                    [
                      topColor,
                      topColor.withOpacity(0.5),
                    ] 
                    : 
                    [
                      primaryColor,
                      thirdColor,
                    ]
                    // stops: [
                    //   0.1,
                    //   0.5,
                    // ],
                  ),
                  center: Text(
                    subj.finalScore!.round().toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: subj.finalScore?.round() != null ? (subj.finalScore?.round() == 10 ? topColor : secondaryColor) : secondaryColor,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(left: 20),
                child: CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 5.0,
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: 1.0,
                  // progressColor: primaryColor,
                  backgroundColor: primaryColor.withOpacity(0.25),
                  // rotateLinearGradient: true,
                  linearGradient: LinearGradient(
                    colors: subj.weightedMean?.round() == subj.finalScore 
                    ? 
                    [
                      positiveColor,
                      positiveColor.withOpacity(0.5),
                    ] 
                    : 
                    [
                      negativeColor,
                      negativeColor.withOpacity(0.5),
                    ]
                    // stops: [
                    //   0.1,
                    //   0.5,
                    // ],
                  ),
                  center: Text(
                    subj.weightedMean?.round() == subj.finalScore ? "o" : "x",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: subj.weightedMean?.round() == subj.finalScore ? positiveColor : negativeColor,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(subj.name, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ), 
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: content,
          ),
        ),
      ),
    );
  }
}