import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SettingsPage {
  List<Widget> _content = [];

  List<Widget> get content {
    return _content;
  }

  void _clear() {
    _content = [];
  }

  void render(Function modifyTheme, Function render) {
    _clear();
    _content.add(const SizedBox(height: 40));

    _content.add(
      Container(
        alignment: AlignmentDirectional.centerStart,
        padding: const EdgeInsets.only(left: 6),
        child: Text("Grades file link:", style: TextStyle(color: CustomTheme.secondaryColor, fontSize: 22, fontWeight: FontWeight.w500)),
      )
    );
    _content.add(const SizedBox(height: 20));
    _content.add(
      TextFormField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: 'Link',
          hintStyle: TextStyle(color: CustomTheme.secondaryColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
    _content.add(const SizedBox(height: 40));
    _content.add(
      Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.only(left: 6),
        child: Text("Theme:", style: TextStyle(color: CustomTheme.secondaryColor, fontSize: 22, fontWeight: FontWeight.w500)),
      )
    );
    _content.add(const SizedBox(height: 20));
    _content.add(
      GridView.count(
        shrinkWrap: true,
        childAspectRatio: 16 / 11,
        physics: const ScrollPhysics(),
        crossAxisCount: 2,
        children: <Widget>[
          Container(
            alignment: AlignmentDirectional.center,
            margin: const EdgeInsets.only(left: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3AA0C2),
                elevation: 0,
              ),
              onPressed: () {
                modifyTheme(
                  primaryColor: const Color(0xFF3AA0C2),
                  selectionColor: const Color.fromARGB(255, 58, 160, 194),
                  backgroundColor: const Color(0xFF19173D),
                  cardBackgroundColor: const Color(0xFF262450),
                  cardBorderColor: const Color(0xFF7B78AA),
                  secondaryColor: const Color(0xFFFFFFFF),
                );
                render();
              },
              child: Container(
                width: 75,
                height: 50,
                alignment: AlignmentDirectional.center,
                child: const Text("Blue", style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
          Container(
            alignment: AlignmentDirectional.center,
            margin: const EdgeInsets.only(right: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 231, 238, 246),
                elevation: 0,
              ),
              onPressed: () {
                modifyTheme(
                  primaryColor: const Color.fromARGB(255, 231, 238, 246),
                  selectionColor: const Color.fromARGB(255, 206, 226, 233),
                  backgroundColor: const Color(0xff2b2f3a),
                  cardBackgroundColor: const Color(0xFF2e3440),
                  cardBorderColor: const Color(0xFF3b4252),
                  secondaryColor: const Color.fromARGB(255, 124, 149, 175),
                );
                render();
              },
              child: Container(
                width: 75,
                height: 50,
                alignment: AlignmentDirectional.center,
                child: const Text("White", style: TextStyle(color: Colors.black),),
              ),
            ),
          ),
        ],
      )
    );
  }
}