import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'constants/colors.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grades Statistics App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: backgroundColor),
        scaffoldBackgroundColor: backgroundColor,
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Grades statistics'),
    );
  }
}
