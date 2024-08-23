import 'package:flutter/material.dart';
import 'homepage.dart';
import 'statspage.dart';
import 'settingspage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../constants/colors.dart';
import '../data/global_grades.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late BuildContext _context;

  List<String> _years = [];
  String? _selectedYear;
  final GlobalGrades _grades = GlobalGrades();

  int _page = 1;
  bool _loaded = false;

  final HomePage _homepage = HomePage();
  final StatsPage _statspage = StatsPage();
  final SettingsPage _settingspage = SettingsPage();

  getGrades() async {

      const url = "https://drive.google.com/uc?export=download&id=1jC9dm9Klvxds60A82hXmywXMWfFydU3Y";

      var response = await http.get(Uri.parse(url));

      // print(jsonDecode(utf8.decode(response.bodyBytes)));

      // return jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> decodedJson = jsonDecode(utf8.decode(response.bodyBytes));

      _grades.yearlyGrades = {};
      _grades.finalGrades = {};

      decodedJson.forEach((year, data) {
        final values = data["values"];
        final finals = data["finals"];
        _grades.yearlyGrades![year] = values;
        _grades.finalGrades![year] = finals;
      });
  }

  void _setYears() {
    _years = [];
    setState(() {
      _grades.yearlyGrades?.forEach((key, value) {
        _years.add(key);
      });
      _years.add("All years");
    });
  }

  void _updateYear(String year) {
    setState(() {
      _selectedYear = year;
    });
  }

  void _updateGrades() {
    setState(() {
      _loaded = false;
    });
    _setYears();
    setState(() {
      _homepage.setGrades = _grades;
      _homepage.setYear = _selectedYear;
      _homepage.render();
      _statspage.setSubjects = _homepage.subjects;
      _statspage.render(_context);
      _settingspage.render();
      _loaded = true;
    });
  }

  void _changeRoute(index) {
    setState(() {
      _page = index;
    });
  }

  void _reFetchGrades () {
    setState(() {
      _loaded = false;
    });
    getGrades().then((_) {
      _updateGrades();
    });
  }

  @override
  void initState() {
    super.initState();
    _reFetchGrades();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _reFetchGrades();
          },
          icon: const Icon(
            Icons.refresh,
            color: primaryColor,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              _updateYear(value);
              _updateGrades();
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
            children: 
              !_loaded 
                ? [
                    const SizedBox(height: 40),
                    const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  ] 
              :
              _page == 0 ? _statspage.content
              :
              _page == 1 ? _homepage.content
              :
              _page == 2 ? _settingspage.content
              :
              []
            ,
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: backgroundColor.withOpacity(1),
        index: 1,
        height: 52,
        buttonBackgroundColor: cardBackgroundColor.withOpacity(0.5),
        color: cardBackgroundColor.withOpacity(0.5),
        animationDuration: const Duration(milliseconds: 300),
        items: <Widget>[
          Icon(Icons.bar_chart, size: 26, color: _page == 0 ? primaryColor : secondaryColor),
          Icon(Icons.home, size: 26, color: _page == 1 ? primaryColor : secondaryColor),
          Icon(Icons.settings, size: 26, color: _page == 2 ? primaryColor : secondaryColor),
        ],
        onTap: (index) {
          _changeRoute(index);
        },
      ),
    );
  }
}