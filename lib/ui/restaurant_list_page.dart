import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/common/styles.dart';
import 'package:restaurant_app_flutter/common/navigation.dart';
import 'package:restaurant_app_flutter/provider/restaurant_provider.dart';
import 'package:restaurant_app_flutter/ui/search_page.dart';
import 'package:restaurant_app_flutter/utils/result_state.dart';
import 'package:restaurant_app_flutter/widget/build_restaurant_item.dart';
import 'package:restaurant_app_flutter/widget/custom_android_app_bar.dart';
import 'package:restaurant_app_flutter/widget/empty_list.dart';
import 'package:restaurant_app_flutter/widget/no_connection_widget.dart';
import 'package:restaurant_app_flutter/widget/platform_widget.dart';

class RestaurantListPage extends StatelessWidget {
  static const title = 'Restaurant';

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
                return AnimationLimiter(
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: state.result.restaurants.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: buildRestaurantItem(
                                  context, state.result.restaurants[index]),
                            ),
                          ),
                        );
                      }),
                );
              } else if (state.state == ResultState.NoData) {
                return Center(
                    child: EmptyWidget(
                        message: 'Data not displayed successfully'));
              } else if (state.state == ResultState.Error) {
                return Center(child: NoConnectionWidget());
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: textStyle.copyWith(fontSize: 22),
            ),
            IconButton(
              key: Key('search'),
              icon: Icon(CupertinoIcons.search),
              onPressed: () {
                Navigation.intentRoute(_createRouteToSearch());
              },
            )
          ],
        ),
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
            Navigation.intentRoute(_createRouteToSearch());
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

Route _createRouteToSearch() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, -1.0);
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
