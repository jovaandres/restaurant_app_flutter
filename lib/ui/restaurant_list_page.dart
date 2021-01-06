import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/common/constant.dart';
import 'package:restaurant_app_flutter/common/navigation.dart';
import 'package:restaurant_app_flutter/provider/restaurant_provider.dart';
import 'package:restaurant_app_flutter/ui/search_page.dart';
import 'package:restaurant_app_flutter/utils/result_state.dart';
import 'package:restaurant_app_flutter/widget/build_restaurant_item.dart';
import 'package:restaurant_app_flutter/widget/empty_list.dart';
import 'package:restaurant_app_flutter/widget/no_connection_widget.dart';
import 'package:restaurant_app_flutter/widget/platform_widget.dart';

class RestaurantListPage extends StatelessWidget {
  static const routeName = '/restaurant_list';
  static const title = 'Restaurant';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textStyle.copyWith(fontSize: 24),
            ),
            Text(
              'Recommendation restaurant for you!',
              style: textStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size(0, 8),
          child: SizedBox(
            height: 8,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.search),
            onPressed: () {
              Navigation.intent(SearchPage.routeName);
            },
          )
        ],
      ),
      body: _buildList(),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          title,
          style: textStyle.copyWith(fontSize: 18),
        ),
        trailing: IconButton(
          icon: Icon(CupertinoIcons.search),
          onPressed: () {
            Navigation.intent(SearchPage.routeName);
          },
        ),
      ),
      child: SafeArea(
        child: _buildList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iOSBuilder: _buildIOS,
    );
  }
}

Widget _buildList() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Expanded(
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
