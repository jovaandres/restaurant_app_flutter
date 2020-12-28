import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_app_flutter/api/api_service.dart';
import 'package:restaurant_app_flutter/model/restaurant_detail.dart';

var textStyle = TextStyle(fontFamily: 'Montserrat');

class RestaurantDetail extends StatefulWidget {
  static const routeName = '/restaurant_detail';
  final String restaurantsId;

  RestaurantDetail({@required this.restaurantsId});

  @override
  _RestaurantDetailState createState() =>
      _RestaurantDetailState(restaurantsId: restaurantsId);
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  final String restaurantsId;
  final myController = TextEditingController();
  Future<RestaurantResult> detailRestaurant;
  List<List<String>> description = [
    ['Bagas', 'Bagus', '3']
  ];

  _RestaurantDetailState({this.restaurantsId});

  @override
  void initState() {
    super.initState();
    detailRestaurant = ApiService().getRestaurantDetail(restaurantsId);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: FutureBuilder(
        future: detailRestaurant,
        builder: (context, AsyncSnapshot<RestaurantResult> snapshot) {
          var state = snapshot.connectionState;
          if (state != ConnectionState.done) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: CircularProgressIndicator()));
          } else {
            if (snapshot.hasData) {
              DetailRestaurant detailRestaurant = snapshot.data.restaurant;
              return SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Hero(
                          tag: detailRestaurant,
                          child: Image.network(
                            'https://restaurant-api.dicoding.dev/images/medium/${detailRestaurant.pictureId}',
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
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return Center(
                                  child: Image.asset('assets/image_error.png',
                                      width: 60, height: 60));
                            },
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detailRestaurant.name,
                          style: textStyle.copyWith(fontSize: 24),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_pin, size: 20),
                            Text(
                              detailRestaurant.city,
                              style: textStyle.copyWith(fontSize: 16),
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Description',
                          style: textStyle.copyWith(fontSize: 20),
                        ),
                        SizedBox(height: 4),
                        Text(detailRestaurant.description,
                            style: textStyle, textAlign: TextAlign.justify),
                        SizedBox(height: 16),
                        Center(
                            child: Text('Menus',
                                style: textStyle.copyWith(fontSize: 20))),
                        Divider(color: Colors.black),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: detailRestaurant.menus.foods.map((name) {
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            alignment: Alignment.bottomRight,
                                            image:
                                                AssetImage('assets/foods.png')),
                                        color: Colors.orange.withOpacity(0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    width: 160,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(name.name,
                                            style: textStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)))),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: detailRestaurant.menus.drinks.map((name) {
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            alignment: Alignment.bottomRight,
                                            image: AssetImage(
                                                'assets/drinks.png')),
                                        color:
                                            Colors.greenAccent.withOpacity(0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    width: 160,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(name.name,
                                            style: textStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)))),
                              );
                            }).toList(),
                          ),
                        ),
                        Divider(color: Colors.black),
                        SizedBox(height: 16),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Feedback',
                                style: textStyle.copyWith(fontSize: 20),
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
                                            borderRadius:
                                                BorderRadius.circular(24)),
                                        child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('Review Restaurant',
                                                        style:
                                                            textStyle.copyWith(
                                                                fontSize: 20)),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextField(
                                                          controller:
                                                              myController,
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      'Tulis Review'),
                                                        ),
                                                        SizedBox(height: 16),
                                                        RaisedButton(
                                                          color: Colors
                                                              .greenAccent,
                                                          child: Text(
                                                            'SEND',
                                                            style: textStyle
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              ApiService().addReview(
                                                                  restaurantsId,
                                                                  'Jova',
                                                                  myController
                                                                      .text);
                                                              Navigator.pop(
                                                                  context);
                                                            });
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
                        ),
                        SizedBox(height: 16),
                        Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text('User Review',
                                style: textStyle.copyWith(fontSize: 20))),
                        Container(
                            height: 75 *
                                (detailRestaurant.customerReviews.length)
                                    .toDouble(),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return _buildReview(context,
                                    detailRestaurant.customerReviews[index]);
                              },
                              itemCount:
                                  detailRestaurant.customerReviews.length,
                            ))
                      ],
                    ),
                  )
                ],
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Text('');
            }
          }
        },
      ),
    ));
  }
}

Widget _buildReview(BuildContext context, CustomerReview review) {
  return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                review.name,
                style: textStyle,
              ),
              SizedBox(width: 4),
              Text(review.date)
            ],
          ),
          SizedBox(height: 12),
          Text(
            review.review,
            style: textStyle,
          ),
          Divider(color: Colors.black)
        ],
      ));
}
