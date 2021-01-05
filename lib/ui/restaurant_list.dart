import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/common/constant.dart';
import 'package:restaurant_app_flutter/provider/restaurant_provider.dart';
import 'package:restaurant_app_flutter/ui/search_page.dart';
import 'package:restaurant_app_flutter/widget/build_restaurant_item.dart';
import 'package:restaurant_app_flutter/main.dart';
import 'package:restaurant_app_flutter/widget/custom_app_bar.dart';
import 'package:restaurant_app_flutter/widget/empty_list.dart';
import 'package:restaurant_app_flutter/widget/no_connection_widget.dart';

class MainPage extends StatelessWidget {
  static const routeName = '/restaurant_list';
  final Widget buildList = ChangeNotifierProvider<RestaurantProvider>(
    create: (_) => RestaurantProvider(apiService: apiService),
    child: _buildList(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBar(
          onPressed: () {
            Navigator.pushNamed(context, SearchPage.routeName);
          },
        ),
      ),
      body: buildList,
    );
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
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.state == ResultState.HasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: state.result.restaurants.length,
                  itemBuilder: (context, index) {
                    return buildRestaurantItem(
                        context, state.result.restaurants[index]);
                  });
            } else if (state.state == ResultState.NoData) {
              return EmptyWidget(message: 'Data tidak berhasil ditampilkan');
            } else if (state.state == ResultState.Error) {
              return NoConnectionWidget();
            } else {
              return Center(
                child: Text(''),
              );
            }
          },
        ),
      )
    ],
  );
}
