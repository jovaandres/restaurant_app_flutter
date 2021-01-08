import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/ui/detail_page.dart';
import 'package:restaurant_app_flutter/ui/favorites_page.dart';
import 'package:restaurant_app_flutter/ui/restaurant_list_page.dart';
import 'package:restaurant_app_flutter/ui/setting_page.dart';
import 'package:restaurant_app_flutter/utils/background_service.dart';
import 'package:restaurant_app_flutter/utils/notification_helper.dart';
import 'package:restaurant_app_flutter/widget/platform_widget.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  PageController _pageController;

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  List<Widget> _listWidget = [
    RestaurantListPage(),
    FavoritePage(),
    SettingPage(),
  ];

  List<BottomNavigationBarItem> _bottomBarItem = [
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.house_fill), label: RestaurantListPage.title),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.heart_fill), label: 'Favorite'),
    BottomNavigationBarItem(
        icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
        label: SettingPage.title)
  ];

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        },
        items: _bottomBarItem,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            this._bottomNavIndex = newIndex;
          });
        },
        children: _listWidget,
      ),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _bottomBarItem,
      ),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }

  @override
  void initState() {
    super.initState();
    port.listen((_) async => await _service.someTask());
    _pageController = PageController(initialPage: _bottomNavIndex);
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetail.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iOSBuilder: _buildIOS,
    );
  }
}
