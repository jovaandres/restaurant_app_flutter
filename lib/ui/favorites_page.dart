import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/data/db/database_helper.dart';
import 'package:restaurant_app_flutter/provider/database_provider.dart';
import 'package:restaurant_app_flutter/utils/result_state.dart';
import 'package:restaurant_app_flutter/widget/build_restaurant_item.dart';
import 'package:restaurant_app_flutter/widget/empty_list.dart';

class FavoritePage extends StatelessWidget {
  static const routeName = '/favorite_page';

  final Widget buildList = ChangeNotifierProvider<DatabaseProvider>(
    create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
    child: _buildList(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Restaurants'),
      ),
      body: buildList,
    );
  }
}

Widget _buildList() {
  return Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Expanded(
        flex: 9,
        child: Consumer<DatabaseProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.state == ResultState.HasData) {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  return buildRestaurantItem(context, state.favorites[index]);
                },
              );
            } else if (state.state == ResultState.NoData) {
              return EmptyWidget(
                message: 'Belum ada restaurant favorite',
              );
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
