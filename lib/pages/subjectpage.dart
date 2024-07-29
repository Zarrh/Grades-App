import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),),
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}