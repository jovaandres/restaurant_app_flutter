import 'package:flutter/material.dart';

final Color _primaryColor = Colors.lightBlue;
final Color _secondaryColor = Colors.lightBlueAccent;
final Color _darkPrimaryColor = Color(0xFF000000);
final Color _darkSecondaryColor = Color(0xff64ffda);
final TextStyle textStyle = TextStyle(fontFamily: 'Montserrat');

ThemeData lightTheme = ThemeData(
    primaryColor: _primaryColor,
    primaryColorDark: Colors.grey[350],
    accentColor: _secondaryColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: IconThemeData(color: Colors.green),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.blueGrey[100],
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.blueGrey[700]));

ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: _darkPrimaryColor,
    primaryColorDark: Colors.grey[900],
    accentColor: _darkSecondaryColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black26,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey));
