import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app_flutter/common/constant.dart';
import 'package:restaurant_app_flutter/common/navigation.dart';
import 'package:restaurant_app_flutter/data/model/restaurant.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

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
      requestSoundPermission: false,
    );

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

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filepath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filepath);
    await file.writeAsBytes(response.bodyBytes);
    return filepath;
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurant restaurant) async {
    var _channelId = '1';
    var _channelName = 'channel_01';
    var _channelDescription = 'restaurant_channel';

    var _remindedRestaurant = (restaurant.restaurants..shuffle()).first;
    var _restaurantPicture = await _downloadAndSaveFile(
        smallImage + _remindedRestaurant.pictureId, 'restaurantPict');

    var bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(_restaurantPicture),
        htmlFormatContentTitle: true,
        contentTitle: '<b>Explore New Resaurant</b>',
        htmlFormatSummaryText: true,
        summaryText: 'Recommended for you today: ${_remindedRestaurant.name}');

    var androidPlatformChannelSpesifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: bigPictureStyleInformation);

    var iOSPlatformChannelSpesifics = IOSNotificationDetails();

    var platformChannelSpesifics = NotificationDetails(
        android: androidPlatformChannelSpesifics,
        iOS: iOSPlatformChannelSpesifics);

    var titleNotification = 'Recommended restaurant';
    var titleRestaurant = _remindedRestaurant.name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleRestaurant, platformChannelSpesifics,
        payload: _remindedRestaurant.id);
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      Navigation.intentWithData(route, payload);
    });
  }
}
