import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../data/subject.dart';
import '../data/grade.dart';
import '../components/custom_box.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key, required this.subj});

  final Subject subj;

  @override
  Widget build(BuildContext context) {

    final List<Widget> _content = [];
    _content.add(const SizedBox(height: 40));

    for (final grade in subj.grades) {
      _content.add(
        CustomBox(
          child: Text(grade.value.toString(), style: const TextStyle(color: secondaryColor))
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
            children: _content,
          ),
        ),
      ),
    );
  }
}