import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_app_flutter/detail_page.dart';
import 'package:restaurant_app_flutter/model/restaurant.dart';

var textStyle = TextStyle(fontFamily: 'Montserrat');

class CustomAppBar extends PreferredSize {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurant',
              style: textStyle.copyWith(fontSize: 24),
            ),
            Text(
              'Recommendation restaurant for you!',
              style:
                  textStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8)
          ],
        ));
  }
}

class MainPage extends StatefulWidget {
  static const routeName = '/restaurant_list';

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "";
  List<Restaurants> restaurants;

  @override
  void initState() {
    super.initState();
    _searchQuery = TextEditingController();
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("");
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search Restaurant...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery.text == "" || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: _isSearching ? _buildSearchField() : CustomAppBar(),
        actions: _buildActions(),
      ),
      body: new Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 9,
                    child: FutureBuilder<String>(
                      future: DefaultAssetBundle.of(context)
                          .loadString('assets/local_restaurant.json'),
                      builder: (context, snapshot) {
                        List<Restaurants> list = parseRestaurant(snapshot.data);
                        restaurants = searchQuery != ""
                            ? list
                                .where((i) => i.name
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase()))
                                .toList()
                            : list;
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
      ),
    );
  }
}

Widget _buildRestaurantItem(BuildContext context, Restaurants restaurant) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, RestaurantDetail.routeName,
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

List<Restaurants> parseRestaurant(String json) {
  if (json == null) {
    return [];
  }

  Restaurant restaurant = Restaurant.fromJson(jsonDecode(json));
  return restaurant.restaurants;
}
