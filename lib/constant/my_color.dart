import 'package:flutter/material.dart';

class MyColor {

  static final Color mainColor = Colors.orangeAccent;

  static final Color deepMainColor = Colors.orangeAccent[700];

  static final Color lightMainColor = Colors.orangeAccent[100];

  static final Color backgroundColor = Color.fromRGBO(240, 243, 245, 1);

  static const MaterialColor orangeThemeColor = MaterialColor(
    0xFFFFAB40,
    <int, Color>{
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE19E),
      200: Color(0xFFFFD180),
      300: Color(0xFFFFB74D),
      400: Color(0xFFFFA030),
      500: Color(0xFFFFAB40),
      600: Color(0xFFFF9100),
      700: Color(0xFFFF6D00),
      800: Color(0xFFEF6C00),
      900: Color(0xFFE65100),
    },
  );

  static final List<Color> colorList = [
    Colors.red[100],
    Colors.orange[100],
    Colors.green[100],
    Colors.cyan[100],
    Colors.blue[100],
    Colors.purple[100],
    Colors.indigoAccent[100],
    Colors.pinkAccent[100],
    Colors.amber[100],
    Colors.indigo[100],
  ];

  static Color getDark(Color color, {int level = 30}) {
    int red = color.red - level <= 0 ? color.red : color.red - level;
    int green = color.green - level <= 0 ? color.green : color.green - level;
    int blue = color.blue - level <= 0 ? color.blue : color.blue - level;
    return Color.fromRGBO(red, green, blue, 1);
  }

  static Color getLight(Color color, {int level = 30}) {
    int red = color.red + level >= 255 ? color.red : color.red + level;
    int green = color.green + level >= 255 ? color.green : color.green + level;
    int blue = color.blue + level >= 255 ? color.blue : color.blue + level;
    return Color.fromRGBO(red, green, blue, 1);
  }

}
