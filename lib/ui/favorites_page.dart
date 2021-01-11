import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/common/styles.dart';
import 'package:restaurant_app_flutter/provider/database_provider.dart';
import 'package:restaurant_app_flutter/utils/result_state.dart';
import 'package:restaurant_app_flutter/widget/build_restaurant_item.dart';
import 'package:restaurant_app_flutter/widget/custom_android_app_bar.dart';
import 'package:restaurant_app_flutter/widget/empty_list.dart';
import 'package:restaurant_app_flutter/widget/platform_widget.dart';

class FavoritePage extends StatelessWidget {
  static const title = 'Favorite Restaurants';
  static const routeName = '/favorite_page';

  Widget _buildList() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Consumer<DatabaseProvider>(
            builder: (context, state, _) {
              final favorites = state.favorites;
              if (state.state == ResultState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.state == ResultState.HasData) {
                return AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Dismissible(
                              key: Key(favorites[index].id),
                              child:
                                  buildFavoriteItem(context, favorites[index]),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                state.removeFavorite(favorites[index].id);
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Deleted from favorite',
                                      style: textStyle.copyWith(
                                          color: Colors.white),
                                    ),
                                    backgroundColor: Colors.black45,
                                    action: SnackBarAction(
                                      label: 'UNDO',
                                      textColor: Colors.lightBlueAccent,
                                      onPressed: () {
                                        state.addFavorite(favorites[index]);
                                      },
                                    ),
                                  ),
                                );
                              },
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.all(12),
                                color: Colors.red,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'DELETE',
                                      style: textStyle.copyWith(fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state.state == ResultState.NoData) {
                return Center(
                    child: EmptyWidget(
                  message: 'There is no favorite restaurant yet',
                ));
              } else {
                return Center(child: Text(''));
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: CustomAndroidAppBar(
        child: Center(
          child: Text(
            title,
            style: textStyle.copyWith(fontSize: 22),
          ),
        ),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
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
