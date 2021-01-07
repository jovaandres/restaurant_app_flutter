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

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  List<Widget> _listWidget = [
    RestaurantListPage(),
    FavoritePage(),
    SettingPage(),
  ];

  List<BottomNavigationBarItem> _bottomBarItem = [
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.home), label: RestaurantListPage.title),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.heart_fill), label: 'Favorite'),
    BottomNavigationBarItem(
        icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
        label: SettingPage.title)
  ];

  void _onBotomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomBarItem,
        onTap: _onBotomNavTapped,
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
