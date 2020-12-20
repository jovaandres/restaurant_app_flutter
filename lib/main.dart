import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: new Builder(
          builder: (BuildContext context) {
            return Column(
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
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(-15, -15),
              blurRadius: 22,
              color: Colors.cyan.withOpacity(0.22),
            )
          ],
          color: Colors.grey.withAlpha(100),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      margin: const EdgeInsets.all(4.0),
      child: Wrap(
        // crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Hero(
                  tag: restaurant.id,
                  child: Image.network(
                    restaurant.pictureId,
                    width: 125,
                  ),
                )),
          ),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16),
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
                  RatingBarIndicator(
                    rating: restaurant.rating.toDouble(),
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemSize: 16,
                  )
                ],
              ))
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
  Restaurants restaurants = Restaurants.fromJson(restaurant.toJson());
  Menus menu = Menus.fromJson(restaurants.toJson());
  Foods.fromJson(menu.toJson());
  Drinks.fromJson(menu.toJson());
  return restaurant.restaurants;
}

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';
  final Restaurants restaurants;
  RestaurantDetailPage({@required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0)),
              child: Hero(
                  tag: restaurants.id,
                  child: Image.network(restaurants.pictureId))),
          Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurants.name,
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_pin, size: 20),
                    Text(
                      restaurants.city,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
                SizedBox(height: 16),
                Text('Description'),
                SizedBox(height: 4),
                Text(restaurants.description, textAlign: TextAlign.justify)
              ],
            ),
          )
        ],
      )),
    );
  }
}
