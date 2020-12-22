import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/detail_page.dart';
import 'package:restaurant_app_flutter/model/restaurant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Restaurant App'),
      routes: {
        MyHomePage.routeName: (context) => MyHomePage(title: 'Restaurant App'),
        RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
              restaurants: ModalRoute.of(context).settings.arguments,
            )
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  static const routeName = '/restaurant_list';

  MyHomePage({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: new Builder(
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Restaurant',
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Recommendation restaurant for you!',
                    style: TextStyle(fontSize: 14),
                  )),
              Expanded(
                  flex: 9,
                  child: FutureBuilder<String>(
                    future: DefaultAssetBundle.of(context)
                        .loadString('assets/local_restaurant.json'),
                    builder: (context, snapshot) {
                      final List<Restaurants> restaurants =
                          parseRestaurant(snapshot.data);
                      return ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: restaurants.length,
                          itemBuilder: (context, index) {
                            return _buildRestaurantItem(
                                context, restaurants[index]);
                          });
                    },
                  ))
            ],
          ),
        );
      },
    ));
  }
}

Widget _buildRestaurantItem(BuildContext context, Restaurants restaurant) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, RestaurantDetailPage.routeName,
          arguments: restaurant);
    },
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(-15, -15),
              blurRadius: 22,
              color: Colors.cyan.withOpacity(0.22),
            )
          ],
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(72, 85, 99, 1),
                Color.fromRGBO(41, 50, 60, 1)
              ]),
          color: Colors.grey.withOpacity(1),
          borderRadius: BorderRadius.all(Radius.circular(0))),
      margin: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Hero(
                  tag: restaurant.id,
                  child: Image.network(
                    restaurant.pictureId,
                    width: 125,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loading) {
                      if (loading == null) return child;
                      return Center(
                        heightFactor: 2,
                        child: CircularProgressIndicator(
                          value: loading.expectedTotalBytes != null
                              ? loading.cumulativeBytesLoaded /
                                  loading.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Center(
                          child: Image.asset('assets/image_error.png',
                              width: 60, height: 60));
                    },
                  ),
                )),
          ),
          Expanded(
              flex: 3,
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_pin, size: 20),
                          Text(
                            restaurant.city,
                            textAlign: TextAlign.start,
                          )
                        ],
                      ),
                      SizedBox(height: 12),
                      RatingBarIndicator(
                        rating: restaurant.rating.toDouble(),
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        itemSize: 16,
                      )
                    ],
                  )))
        ],
      ),
    ),
  );
}

List<Restaurants> parseRestaurant(String json) {
  if (json == null) {
    return [];
  }

  Restaurant restaurant = Restaurant.fromJson(jsonDecode(json));
  return restaurant.restaurants;
}
