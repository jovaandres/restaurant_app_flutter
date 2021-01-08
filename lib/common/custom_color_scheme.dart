import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  int get themes => brightness == Brightness.dark ? 0 : 1;

  Color get customAppBarColor =>
      [Colors.grey[900], Colors.blueGrey[100]][themes];

  Color get settingPadColor =>
      [Color.fromRGBO(72, 85, 99, 1), Colors.grey[350]][themes];

  Color get shadowColor => [
        Colors.cyan.withOpacity(0.22),
        Colors.lightBlue.withOpacity(0.22)
      ][themes];

  Color get ratingColor => [Colors.yellow, Colors.amber][themes];

  Color get cardColor =>
      [Color.fromRGBO(72, 85, 99, 1), Colors.blueGrey[50]][themes];

  Color get categoryCardColor => [Colors.lightBlue, Colors.cyanAccent][themes];

  List<Color> get getMenusColor => [
        [Colors.orange.withOpacity(0.2), Colors.greenAccent.withOpacity(0.2)],
        [
          Colors.orangeAccent.withOpacity(0.2),
          Colors.lightGreenAccent[400].withOpacity(0.2)
        ]
      ][themes];
}
