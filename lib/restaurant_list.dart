import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/data/api/api_service.dart';
import 'package:restaurant_app_flutter/detail_page.dart';
import 'package:restaurant_app_flutter/data/model/restaurant.dart';
import 'package:restaurant_app_flutter/provider/restaurant_provider.dart';
import 'package:restaurant_app_flutter/ui/cutom_app_bar.dart';

var textStyle = TextStyle(fontFamily: 'Montserrat');

class MainPage extends StatelessWidget {
  static const routeName = '/restaurant_list';

  @override
  Widget build(BuildContext context) {
    Widget restaurantListPage = ChangeNotifierProvider<RestaurantProvider>(
      create: (_) => RestaurantProvider(apiService: ApiService()),
      child: RestaurantListPage(),
    );
    return restaurantListPage;
  }
}

class RestaurantListPage extends StatelessWidget {
  Widget _buildList() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            flex: 9,
            child: Consumer<RestaurantProvider>(
              builder: (context, state, _) {
                if (state.state == ResultState.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.state == ResultState.HasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: state.result.restaurants.length,
                      itemBuilder: (context, index) {
                        return _buildRestaurantItem(
                            context, state.result.restaurants[index]);
                      });
                } else if (state.state == ResultState.NoData ||
                    state.state == ResultState.Error) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(child: Text('awdaad'));
                }
              },
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: CustomAppBar(
          onPressed: () {},
        )),
        body: _buildList());
  }
}

Widget _buildRestaurantItem(BuildContext context, Restaurants restaurant) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, RestaurantDetail.routeName,
          arguments: restaurant.id);
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
                    'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
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
                        style: textStyle.copyWith(fontSize: 18),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_pin, size: 20),
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
