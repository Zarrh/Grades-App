import 'package:flutter/material.dart';
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