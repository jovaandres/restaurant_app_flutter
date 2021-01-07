import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get customAppBarColor =>
      brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[350];
  Color get settingPadColor => brightness == Brightness.dark
      ? Color.fromRGBO(72, 85, 99, 1)
      : Colors.grey[350];
}
