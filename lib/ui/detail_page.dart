import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/common/constant.dart';
import 'package:restaurant_app_flutter/common/custom_color_scheme.dart';
import 'package:restaurant_app_flutter/common/navigation.dart';
import 'package:restaurant_app_flutter/common/styles.dart';
import 'package:restaurant_app_flutter/data/api/api_service.dart';
import 'package:restaurant_app_flutter/data/model/restaurant.dart';
import 'package:restaurant_app_flutter/data/model/restaurant_detail.dart';
import 'package:restaurant_app_flutter/provider/database_provider.dart';
import 'package:restaurant_app_flutter/provider/detail_provider.dart';
import 'package:restaurant_app_flutter/utils/result_state.dart';
import 'package:restaurant_app_flutter/widget/empty_list.dart';
import 'package:restaurant_app_flutter/widget/no_connection_widget.dart';

class RestaurantDetail extends StatefulWidget {
  static const routeName = '/restaurant_detail';
  final String restaurantsId;

  RestaurantDetail({@required this.restaurantsId});

  @override
  _RestaurantDetailState createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  final _nameFieldController = TextEditingController();
  final _reviewFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<DetailProvider>(context, listen: false)
        .fetchRestaurantDetail(widget.restaurantsId);
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _reviewFieldController.dispose();
    super.dispose();
  }

  Widget snackBar(String content) {
    return SnackBar(
        content: Text(content), duration: Duration(milliseconds: 750));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<DetailProvider>(builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state.state == ResultState.HasData) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: state.result.id,
                        child: Image.network(
                          mediumImage + state.result.pictureId,
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
                              child: Image.asset(
                                'assets/image_error.png',
                                width: 60,
                                height: 60,
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            key: Key('back'),
                            icon: Icon(
                              CupertinoIcons.arrow_left,
                              size: 26,
                            ),
                            onPressed: () {
                              Navigation.back();
                            },
                          ),
                          Consumer<DatabaseProvider>(
                            builder: (context, stateFav, _) {
                              return FutureBuilder<bool>(
                                future: stateFav.isFavorite(state.result.id),
                                builder: (context, snapshot) {
                                  var isFavorite = snapshot.data ?? false;
                                  return IconButton(
                                    key: Key('add to favorite'),
                                    icon: Icon(
                                      isFavorite
                                          ? CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      color: Colors.pinkAccent,
                                    ),
                                    onPressed: () async {
                                      if (isFavorite) {
                                        stateFav
                                            .removeFavorite(state.result.id);
                                        Scaffold.of(context).showSnackBar(
                                            snackBar('Deleted from favorite'));
                                      } else {
                                        stateFav.addFavorite(Restaurants(
                                            id: state.result.id,
                                            name: state.result.name,
                                            description:
                                                state.result.description,
                                            pictureId: state.result.pictureId,
                                            city: state.result.city,
                                            rating: state.result.rating));

                                        Scaffold.of(context).showSnackBar(
                                            snackBar('Added to favorite'));
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
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
                          state.result.name,
                          style: textStyle.copyWith(fontSize: 24),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.location_solid,
                              size: 20,
                            ),
                            Text(
                              state.result.city,
                              style: textStyle.copyWith(fontSize: 16),
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                        Text(
                          state.result.address,
                          style: textStyle.copyWith(fontSize: 14),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Description',
                          style: textStyle.copyWith(fontSize: 20),
                        ),
                        SizedBox(height: 4),
                        Text(
                          state.result.description,
                          style: textStyle,
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Category',
                          style: textStyle.copyWith(fontSize: 16),
                        ),
                        Container(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: state.result.categories.map((category) {
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .categoryCardColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      category.name,
                                      style: textStyle.copyWith(fontSize: 14),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Text(
                            'Menus',
                            style: textStyle.copyWith(fontSize: 20),
                          ),
                        ),
                        Divider(color: Colors.black),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: state.result.menus.foods.map((name) {
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment.bottomRight,
                                      image: AssetImage('assets/foods.png'),
                                    ),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .getMenusColor[0],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  width: 160,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      name.name,
                                      style: textStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: state.result.menus.drinks.map((name) {
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment.bottomRight,
                                      image: AssetImage('assets/drinks.png'),
                                    ),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .getMenusColor[1],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  width: 160,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      name.name,
                                      style: textStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
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
                                      builder: (context) {
                                        return Platform.isAndroid
                                            ? SimpleDialog(
                                                title: Text(
                                                  'Review Restaurant',
                                                  style: textStyle.copyWith(
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            _nameFieldController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: 'Nama Kamu',
                                                        ),
                                                      ),
                                                      Form(
                                                        key: _formKey,
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value.isEmpty) {
                                                              return 'Tulis Review Sedikitnya Satu Kata';
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              _reviewFieldController,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Tulis Review',
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 16),
                                                      RaisedButton(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        child: Text(
                                                          'SEND',
                                                          style: textStyle
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        onPressed: () {
                                                          if (_formKey
                                                              .currentState
                                                              .validate()) {
                                                            ApiService().addReview(
                                                                state.result.id,
                                                                _nameFieldController
                                                                        .text
                                                                        .isNotEmpty
                                                                    ? _nameFieldController
                                                                        .text
                                                                    : 'Anonim',
                                                                _reviewFieldController
                                                                    .text);
                                                            Navigation.back();
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : CupertinoAlertDialog(
                                                title: Text(
                                                  'Review Restaurant',
                                                  style: textStyle.copyWith(
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                content: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 16,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CupertinoTextField(
                                                        controller:
                                                            _nameFieldController,
                                                        placeholder:
                                                            'Nama Kamu',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      CupertinoTextField(
                                                        controller:
                                                            _reviewFieldController,
                                                        placeholder:
                                                            'Tulis Review',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  CupertinoDialogAction(
                                                      child: Text('SEND'),
                                                      onPressed: () {
                                                        ApiService().addReview(
                                                            state.result.id,
                                                            _nameFieldController
                                                                    .text
                                                                    .isNotEmpty
                                                                ? _nameFieldController
                                                                    .text
                                                                : 'Anonim',
                                                            _reviewFieldController
                                                                .text);
                                                        Navigation.back();
                                                      })
                                                ],
                                              );
                                      });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            'User Review',
                            style: textStyle.copyWith(fontSize: 20),
                          ),
                        ),
                        Container(
                          height: (state.result.customerReviews.length) >= 5
                              ? 400.0
                              : (state.result.customerReviews.length * 80)
                                  .toDouble(),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return _buildReview(
                                  context, state.result.customerReviews[index]);
                            },
                            itemCount: state.result.customerReviews.length,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          } else if (state.state == ResultState.NoData) {
            return Center(
                child: EmptyWidget(message: 'Data not displayed successfully'));
          } else if (state.state == ResultState.Error) {
            return Center(child: NoConnectionWidget());
          } else {
            return Center(child: Text(''));
          }
        }),
      ),
    );
  }
}

Widget _buildReview(BuildContext context, CustomerReview review) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    ),
  );
}
