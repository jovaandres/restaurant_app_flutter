import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get customAppBarColor =>
      brightness == Brightness.dark ? Colors.grey[900] : Colors.blueGrey[100];
  Color get settingPadColor => brightness == Brightness.dark
      ? Color.fromRGBO(72, 85, 99, 1)
      : Colors.grey[350];
  Color get shadowColor => brightness == Brightness.dark
      ? Colors.cyan.withOpacity(0.22)
      : Colors.lightBlue.withOpacity(0.22);
  LinearGradient get cardColor => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: brightness == Brightness.dark
          ? [Color.fromRGBO(72, 85, 99, 1), Color.fromRGBO(41, 50, 60, 1)]
          : [Colors.blueGrey[300], Colors.blueGrey[50]]);
}
