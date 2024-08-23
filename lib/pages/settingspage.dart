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

  void render() {
    _clear();
    _content.add(const SizedBox(height: 40));

    _content.add(
      Container(
        alignment: AlignmentDirectional.centerStart,
        padding: const EdgeInsets.only(left: 6),
        child: const Text("Grades file link", style: TextStyle(color: secondaryColor, fontSize: 22, fontWeight: FontWeight.w500)),
      )
    );
    _content.add(const SizedBox(height: 20));
    _content.add(
      TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Link',
          hintStyle: TextStyle(color: secondaryColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}