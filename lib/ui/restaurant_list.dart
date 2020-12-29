import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/common/constant.dart';
import 'package:restaurant_app_flutter/data/api/api_service.dart';
import 'package:restaurant_app_flutter/provider/restaurant_provider.dart';
import 'package:restaurant_app_flutter/ui/cutom_app_bar.dart';
import 'package:restaurant_app_flutter/widget/build_restaurant_item.dart';
import 'package:restaurant_app_flutter/widget/search_page.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/restaurant_list';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget buildList = ChangeNotifierProvider<RestaurantProvider>(
    create: (_) => RestaurantProvider(apiService: ApiService()),
    child: _buildList(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: CustomAppBar(
          onPressed: () {
            Navigator.pushNamed(context, SearchPage.routeName);
          },
        )),
        body: buildList);
  }
}

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
                      return buildRestaurantItem(
                          context, state.result.restaurants[index]);
                    });
              } else if (state.state == ResultState.NoData ||
                  state.state == ResultState.Error) {
                return Center(child: Text(state.message));
              } else {
                return Center(child: Text(''));
              }
            },
          ))
    ],
  );
}
