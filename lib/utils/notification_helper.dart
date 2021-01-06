import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app_flutter/common/navigation.dart';
import 'package:restaurant_app_flutter/data/model/restaurant.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettingIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);

    var initializationSettings = InitializationSettings(
        android: initializationSettingAndroid, iOS: initializationSettingIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        print('notification payload: $payload');
      }
      selectNotificationSubject.add(payload);
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurant restaurant) async {
    var _channelId = '1';
    var _channelName = 'channel_01';
    var _channelDescription = 'restaurant_channel';

    var androidPlatformChannelSpesifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpesifics = IOSNotificationDetails();

    var platformChannelSpesifics = NotificationDetails(
        android: androidPlatformChannelSpesifics,
        iOS: iOSPlatformChannelSpesifics);

    var titleNotification = '<b>Find Restaurant</b>';
    var remindedRestaurant = (restaurant.restaurants..shuffle()).first;
    var titleRestaurant = remindedRestaurant.name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleRestaurant, platformChannelSpesifics,
        payload: jsonEncode(restaurant.toJson()));
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = Restaurant.fromJson(jsonDecode(payload));
      var restaurant = (data.restaurants..shuffle()).first;
      Navigation.intentWithData(route, restaurant.id);
    });
  }
}
