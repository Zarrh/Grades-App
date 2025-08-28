import 'package:flutter/material.dart';
import 'homepage.dart';
import 'statspage.dart';
import 'settingspage.dart';
import 'calcpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../constants/colors.dart';
import '../data/global_grades.dart';
import '../constants/links.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title, required this.modifyTheme});

  final String title;
  final Function modifyTheme;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late BuildContext _context;
  late Function _modifyTheme;

  List<String> _years = [];
  String? _selectedYear;
  final GlobalGrades _grades = GlobalGrades();

  int _page = 0;
  bool _loaded = false;

  final HomePage _homepage = HomePage();
  final StatsPage _statspage = StatsPage();
  final SettingsPage _settingspage = SettingsPage();

  getGrades() async {

    const url = Links.url;

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
      _statspage.setGlobalSubjects = _homepage.globalSubjects;
      _statspage.render(_context);
      _settingspage.render(_modifyTheme, _updateGrades);
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
    _modifyTheme = widget.modifyTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.backgroundColor,
        title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, color: CustomTheme.primaryColor),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _reFetchGrades();
          },
          icon: Icon(
            Icons.refresh,
            color: CustomTheme.primaryColor,
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
                child: Text(year, style: TextStyle(color: CustomTheme.primaryColor)),
              );
            }).toList(),
            color: CustomTheme.backgroundColor,
            iconColor: CustomTheme.primaryColor,
          )
        ], 
      ),
      body: SingleChildScrollView(
        child: Center(
          child: 
          [0, 1, 2].contains(_page) 
          ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: 
              !_loaded 
                ? [
                    const SizedBox(height: 40),
                    Center(
                      child: CircularProgressIndicator(color: CustomTheme.primaryColor),
                    ),
                  ] 
              :
              _page == 0 ? _homepage.content
              :
              _page == 1 ? _statspage.content
              :
              _page == 2 ? _settingspage.content
              :
              []
            ,
          )
          : _page == 3
          ? CalcPage(subjects: _homepage.subjects)
          : Column()
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: CustomTheme.backgroundColor.withOpacity(1),
        index: 0,
        height: 52,
        buttonBackgroundColor: CustomTheme.cardBackgroundColor.withOpacity(0.5),
        color: CustomTheme.cardBackgroundColor.withOpacity(0.5),
        animationDuration: const Duration(milliseconds: 300),
        items: <Widget>[
          Icon(Icons.home, size: 26, color: _page == 0 ? CustomTheme.primaryColor : CustomTheme.secondaryColor),
          Icon(Icons.bar_chart, size: 26, color: _page == 1 ? CustomTheme.primaryColor : CustomTheme.secondaryColor),
          Icon(Icons.settings, size: 26, color: _page == 2 ? CustomTheme.primaryColor : CustomTheme.secondaryColor),
          Icon(Icons.calculate, size: 26, color: _page == 3 ? CustomTheme.primaryColor : CustomTheme.secondaryColor),
        ],
        onTap: (index) {
          _changeRoute(index);
        },
      ),
    );
  }
}