import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/data/api/api_service.dart';
import 'package:restaurant_app_flutter/provider/detail_provider.dart';
import 'package:restaurant_app_flutter/provider/search_provider.dart';
import 'package:restaurant_app_flutter/ui/detail_page.dart';
import 'package:restaurant_app_flutter/ui/restaurant_list.dart';
import 'package:restaurant_app_flutter/widget/search_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant',
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
      routes: {
        MainPage.routeName: (context) => MainPage(),
        RestaurantDetail.routeName: (context) =>
            ChangeNotifierProvider<DetailProvider>(
              create: (_) => DetailProvider(
                  apiService: ApiService(),
                  id: ModalRoute.of(context).settings.arguments),
              child: RestaurantDetail(
                  restaurantsId: ModalRoute.of(context).settings.arguments),
            ),
        SearchPage.routeName: (context) =>
            ChangeNotifierProvider<SearchProvider>(
                create: (_) => SearchProvider(apiService: ApiService()),
                child: SearchPage())
      },
    );
  }
}
