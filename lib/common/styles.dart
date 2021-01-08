import 'package:flutter/material.dart';

final Color primaryColor = Color(0xFFFFFFFF);
final Color secondaryColor = Colors.lightBlueAccent;
final Color darkPrimaryColor = Color(0xFF000000);
final Color darkSecondaryColor = Color(0xff64ffda);

ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: Colors.grey[350],
    accentColor: secondaryColor,
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: IconThemeData(color: Colors.green),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.blueGrey[100],
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.blueGrey[700]));

ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: darkPrimaryColor,
    primaryColorDark: Colors.grey[900],
    accentColor: darkSecondaryColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black26,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey));
