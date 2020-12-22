import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_app_flutter/model/restaurant.dart';

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
              tag: restaurants.id,
              child: Image.network(
                restaurants.pictureId,
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
              )),
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
                Center(child: Text('Menus', style: TextStyle(fontSize: 20))),
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
                Divider(color: Colors.black),
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
                Center(
                  child: Column(
                    children: [
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
                        onRatingUpdate: (rating) {
                          showDialog(
                              context: context,
                              child: Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                child: Container(
                                    width: 200,
                                    height: 200,
                                    child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Review Restaurant',
                                                style: TextStyle(fontSize: 20)),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                TextField(
                                                  decoration: InputDecoration(
                                                      hintText: 'Tulis Review'),
                                                ),
                                                SizedBox(height: 16),
                                                RaisedButton(
                                                  color: Colors.greenAccent,
                                                  child: Text('SEND'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            ),
                                          ],
                                        ))),
                              ));
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      )),
    ));
  }
}
