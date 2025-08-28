import 'package:flutter/material.dart';

// Green version
// const primaryColor = Color.fromARGB(255, 114, 176, 167);
// const selectionColor = Color(0xFF88B2AC);
// const backgroundColor = Color(0xFF15131C);
// const cardBackgroundColor = Color(0xFF21222D);
// const cardBorderColor = Color.fromARGB(255, 66, 68, 89);
////////

// Blue version
// const primaryColor = Color(0xFF3AA0C2);
// const selectionColor = Color.fromARGB(255, 58, 160, 194);
// const backgroundColor = Color(0xFF19173D);
// const cardBackgroundColor = Color(0xFF262450);
// const cardBorderColor = Color(0xFF7B78AA);

// const secondaryColor = Color(0xFFFFFFFF);
////////

// Gray version
// const primaryColor = Color.fromARGB(255, 231, 238, 246);
// const selectionColor = Color.fromARGB(255, 206, 226, 233);
// const backgroundColor = Color(0xff2b2f3a);
// const cardBackgroundColor = Color(0xFF2e3440);
// const cardBorderColor = Color(0xFF3b4252);

// const secondaryColor = Color.fromARGB(255, 124, 149, 175);
////////

class CustomTheme {
  
  static Color primaryColor = const Color.fromARGB(255, 231, 238, 246);
  static Color selectionColor = const Color.fromARGB(255, 206, 226, 233);
  static Color backgroundColor = const Color(0xff2b2f3a);
  static Color cardBackgroundColor = const Color(0xFF2e3440);
  static Color cardBorderColor = const Color(0xFF3b4252);

  static Color secondaryColor = const Color.fromARGB(255, 124, 149, 175);

  static void updateTheme({
    Color? primaryColor,
    Color? selectionColor,
    Color? backgroundColor,
    Color? cardBackgroundColor,
    Color? cardBorderColor,
    Color? secondaryColor,
  }) {
    if (primaryColor != null) CustomTheme.primaryColor = primaryColor;
    if (selectionColor != null) CustomTheme.selectionColor = selectionColor;
    if (backgroundColor != null) CustomTheme.backgroundColor = backgroundColor;
    if (cardBackgroundColor != null) CustomTheme.cardBackgroundColor = cardBackgroundColor;
    if (cardBorderColor != null) CustomTheme.cardBorderColor = cardBorderColor;
    if (secondaryColor != null) CustomTheme.secondaryColor = secondaryColor;
  }
}

const thirdColor = Color.fromARGB(255, 134, 64, 180);

const positiveColor = Color.fromARGB(255, 29, 255, 116);
const negativeColor = Color.fromARGB(255, 255, 10, 10);
const topColor = Color.fromARGB(255, 255, 197, 22);

const subjectColors = {
  "filosofia": Color.fromARGB(255, 170, 249, 237),
  "fisica": Color.fromARGB(255, 165, 52, 247),
  "informatica": Color.fromARGB(255, 0, 155, 0),
  "matematica": Color.fromARGB(255, 214, 21, 21),
  "storia": Color.fromARGB(255, 244, 192, 21),
  "scienze naturali": Color.fromARGB(255, 40, 254, 7),
  "religione cattolica": Color.fromARGB(255, 226, 227, 227),
  "lingua e letteratura italiana": Color.fromARGB(255, 255, 148, 26),
  "educazione civica": Color.fromARGB(255, 255, 242, 125),
  "disegno e storia dell'arte": Color.fromARGB(255, 225, 83, 161),
  "educazione fisica": Color.fromARGB(255, 144, 145, 145),
  "lingua straniera inglese": Color.fromARGB(255, 14, 57, 212),
};