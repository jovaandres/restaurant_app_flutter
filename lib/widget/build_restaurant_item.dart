import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_app_flutter/common/constant.dart';
import 'package:restaurant_app_flutter/common/styles.dart';
import 'package:restaurant_app_flutter/common/navigation.dart';
import 'package:restaurant_app_flutter/data/model/restaurant.dart';
import 'package:restaurant_app_flutter/ui/detail_page.dart';
import 'package:restaurant_app_flutter/common/custom_color_scheme.dart';

Widget buildRestaurantItem(BuildContext context, Restaurants restaurant) {
  return GestureDetector(
    key: Key(restaurant.name),
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
            color: Theme.of(context).colorScheme.shadowColor,
          )
        ],
        color: Theme.of(context).colorScheme.cardColor,
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
                        color: Theme.of(context).colorScheme.ratingColor),
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

Widget buildFavoriteItem(BuildContext context, Restaurants restaurant) {
  return GestureDetector(
    onTap: () {
      Navigation.intentRoute(_createRouteToDetail(restaurant.id));
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(-15, -15),
            blurRadius: 22,
            color: Theme.of(context).colorScheme.shadowColor,
          )
        ],
        color: Theme.of(context).colorScheme.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      margin: const EdgeInsets.all(4.0),
      child: Column(
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
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Hero(
              tag: restaurant.id,
              child: Image.network(
                smallImage + restaurant.pictureId,
                height: 175,
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
          RatingBarIndicator(
            rating: restaurant.rating.toDouble(),
            direction: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => Icon(CupertinoIcons.star_fill,
                color: Theme.of(context).colorScheme.ratingColor),
            itemSize: 16,
          ),
          SizedBox(height: 8),
          Text(
            restaurant.description,
            textAlign: TextAlign.justify,
            style: textStyle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
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
