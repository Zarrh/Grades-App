import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../constants/colors.dart';
import '../data/subject.dart';
import '../data/global_subject.dart';
import '../components/custom_box.dart';
import '../data/computing_model.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({
    super.key, 
    required this.subj, 
    this.globalSubj, 
  });

  final Subject subj;
  final GlobalSubject? globalSubj;

  @override
  Widget build(BuildContext context) {

    final List<Widget> content = [];
    final ComputingModel model = ComputingModel(subj: subj, globalSubj: globalSubj);

    model.beta();

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
              child: Text("Score", style: TextStyle(color: CustomTheme.primaryColor, fontSize: 26, fontWeight: FontWeight.bold))
            ),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              child: Text("Date", style: TextStyle(color: CustomTheme.primaryColor, fontSize: 26, fontWeight: FontWeight.bold))
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
                  child: Text(grade.date.toString(), style: TextStyle(color: CustomTheme.secondaryColor, fontSize: 24))
                ),
              ],
            )
          ) 
        )        
      );
    }

    content.add(const SizedBox(height: 40));

    content.add(
      Text("Predictions", style: TextStyle(color: CustomTheme.primaryColor, fontSize: 26, fontWeight: FontWeight.w500))
    );

    content.add(const SizedBox(height: 20));

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
              child: Text("Grade", style: TextStyle(color: CustomTheme.secondaryColor, fontSize: 26, fontWeight: FontWeight.w500)),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              margin: const EdgeInsets.only(left: 20),
              child: Text("Trust", style: TextStyle(color: CustomTheme.secondaryColor, fontSize: 26, fontWeight: FontWeight.w500)),
            ),
            Container(
              alignment: AlignmentDirectional.center,
              margin: const EdgeInsets.only(right: 20),
              child: CircularPercentIndicator(
                radius: 45.0,
                lineWidth: 5.0,
                circularStrokeCap: CircularStrokeCap.round,
                percent: (model.v?.toDouble() ?? 0) / 10,
                // progressColor: primaryColor,
                backgroundColor: CustomTheme.primaryColor.withOpacity(0.25),
                // rotateLinearGradient: true,
                linearGradient: LinearGradient(
                  colors: model.v == 10 
                  ? 
                  [
                    topColor,
                    topColor.withOpacity(0.5),
                  ] 
                  : 
                  [
                    CustomTheme.primaryColor,
                    thirdColor,
                  ]
                  // stops: [
                  //   0.1,
                  //   0.5,
                  // ],
                ),
                center: Text(
                  model.v?.toString() ?? "N/D",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: model.v != null ? (model.v == 10 ? topColor : CustomTheme.secondaryColor) : CustomTheme.secondaryColor,
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
                percent: (model.trust?.toDouble() ?? 0),
                // progressColor: primaryColor,
                backgroundColor: CustomTheme.primaryColor.withOpacity(0.25),
                // rotateLinearGradient: true,
                linearGradient: LinearGradient(
                  colors: model.trust == 1 
                  ? 
                  [
                    topColor,
                    topColor.withOpacity(0.5),
                  ] 
                  : 
                  [
                    CustomTheme.primaryColor,
                    thirdColor,
                  ]
                  // stops: [
                  //   0.1,
                  //   0.5,
                  // ],
                ),
                center: Text(
                  model.trust?.toStringAsFixed(3) ?? "N/D",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: model.trust == 1 ? topColor : CustomTheme.secondaryColor,
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
      Text("Results", style: TextStyle(color: CustomTheme.primaryColor, fontSize: 26, fontWeight: FontWeight.w500))
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
                child: Text("Grade", style: TextStyle(color: CustomTheme.secondaryColor, fontSize: 26, fontWeight: FontWeight.w500)),
              ),
              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(left: 20),
                child: Text("Accuracy", style: TextStyle(color: CustomTheme.secondaryColor, fontSize: 26, fontWeight: FontWeight.w500)),
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
                  backgroundColor: CustomTheme.primaryColor.withOpacity(0.25),
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
                      CustomTheme.primaryColor,
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
                      color: subj.finalScore?.round() != null ? (subj.finalScore?.round() == 10 ? topColor : CustomTheme.secondaryColor) : CustomTheme.secondaryColor,
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
                  backgroundColor: CustomTheme.primaryColor.withOpacity(0.25),
                  // rotateLinearGradient: true,
                  linearGradient: LinearGradient(
                    colors: model.v == subj.finalScore 
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
                    model.v == subj.finalScore ? "o" : "x",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: model.v == subj.finalScore ? positiveColor : negativeColor,
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
        backgroundColor: CustomTheme.backgroundColor,
        title: Text(subj.name, style: TextStyle(fontWeight: FontWeight.bold, color: CustomTheme.primaryColor),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: CustomTheme.primaryColor,
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