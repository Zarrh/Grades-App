import 'package:flutter/material.dart';
import 'pages/mainscreen.dart';
import 'constants/colors.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void modifyTheme({
      Color? primaryColor,
      Color? selectionColor,
      Color? backgroundColor,
      Color? cardBackgroundColor,
      Color? cardBorderColor,
      Color? secondaryColor,
    }) {
    setState(() {
      CustomTheme.updateTheme(
        primaryColor: primaryColor,
        selectionColor: selectionColor,
        backgroundColor: backgroundColor,
        cardBackgroundColor: cardBackgroundColor,
        cardBorderColor: cardBorderColor,
        secondaryColor: secondaryColor,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grades Statistics App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: CustomTheme.backgroundColor,
        useMaterial3: true,
      ),
      home: MainScreen(title: "Grades Statistics", modifyTheme: modifyTheme),
    );
  }
}
