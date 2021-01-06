import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_app_flutter/common/constant.dart';
import 'package:restaurant_app_flutter/common/navigation.dart';
import 'package:restaurant_app_flutter/data/model/restaurant.dart';
import 'package:restaurant_app_flutter/ui/detail_page.dart';

Widget buildRestaurantItem(BuildContext context, Restaurants restaurant) {
  return GestureDetector(
    onTap: () {
      Navigation.intentRoute(_createRouteToDetail(restaurant.id));
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
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
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
                  smallImage + restaurant.pictureId,
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
                      child: Image.asset(
                        'assets/image_error.png',
                        width: 60,
                        height: 60,
                      ),
                    );
                  },
                ),
              ),
            ),
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
                    style: textStyle.copyWith(fontSize: 18),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        size: 20,
                      ),
                      Text(
                        restaurant.city,
                        style: textStyle,
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
                      CupertinoIcons.star_fill,
                      color: Colors.yellow,
                    ),
                    itemSize: 16,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Route _createRouteToDetail(String id) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          RestaurantDetail(restaurantsId: id),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, -1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}
