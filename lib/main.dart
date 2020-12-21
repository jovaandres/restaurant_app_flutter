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
        body: SingleChildScrollView(
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
              tag: restaurants.id, child: Image.network(restaurants.pictureId)),
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
                Text(restaurants.description, textAlign: TextAlign.justify),
                SizedBox(height: 16),
                Text(
                  'Menus',
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: restaurants.menus.foods.map((name) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    alignment: Alignment.bottomRight,
                                    image: AssetImage('assets/foods.png')),
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            width: 160,
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(name.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)))),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: restaurants.menus.drinks.map((name) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    alignment: Alignment.bottomRight,
                                    image: AssetImage('assets/drinks.png')),
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            width: 160,
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(name.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)))),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Feedback',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 8),
                RatingBar.builder(
                  initialRating: 0,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: Colors.red,
                        );
                      case 1:
                        return Icon(
                          Icons.sentiment_dissatisfied,
                          color: Colors.deepOrangeAccent,
                        );
                      case 2:
                        return Icon(
                          Icons.sentiment_neutral,
                          color: Colors.amber,
                        );
                      case 3:
                        return Icon(
                          Icons.sentiment_satisfied,
                          color: Colors.lightGreen,
                        );
                      case 4:
                        return Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                        );
                      default:
                        return Icon(
                          Icons.sentiment_neutral,
                          color: Colors.grey,
                        );
                    }
                  },
                  onRatingUpdate: (rating) {},
                )
              ],
            ),
          )
        ],
      )),
    ));
  }
}
