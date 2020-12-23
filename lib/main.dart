import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/detail_page.dart';
import 'package:restaurant_app_flutter/restaurant_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
      routes: {
        MainPage.routeName: (context) => MainPage(),
        RestaurantDetail.routeName: (context) => RestaurantDetail(
              restaurants: ModalRoute.of(context).settings.arguments,
            )
      },
    );
  }
}
