import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/common/navigation.dart';
import 'package:restaurant_app_flutter/common/styles.dart';
import 'package:restaurant_app_flutter/data/api/api_service.dart';
import 'package:restaurant_app_flutter/data/db/database_helper.dart';
import 'package:restaurant_app_flutter/data/preferences/preferences_helper.dart';
import 'package:restaurant_app_flutter/provider/database_provider.dart';
import 'package:restaurant_app_flutter/provider/detail_provider.dart';
import 'package:restaurant_app_flutter/provider/preferences_provider.dart';
import 'package:restaurant_app_flutter/provider/restaurant_provider.dart';
import 'package:restaurant_app_flutter/provider/scheduling_provider.dart';
import 'package:restaurant_app_flutter/provider/search_provider.dart';
import 'package:restaurant_app_flutter/ui/detail_page.dart';
import 'package:restaurant_app_flutter/ui/home_page.dart';
import 'package:restaurant_app_flutter/utils/background_service.dart';
import 'package:restaurant_app_flutter/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ApiService apiService = ApiService();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotification(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(apiService: apiService),
        ),
        ChangeNotifierProvider<DetailProvider>(
          create: (_) => DetailProvider(apiService: apiService),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (_) => SearchProvider(apiService: apiService),
        ),
        ChangeNotifierProvider<DatabaseProvider>(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
        ChangeNotifierProvider<PreferencesProvider>(
          create: (_) => PreferencesProvider(
              preferencesHelper: PreferencesHelper(
                  sharedPreferences: SharedPreferences.getInstance())),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
          create: (_) => SchedulingProvider(),
        )
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Restaurant',
            theme: provider.isDarkTheme ? darkTheme : lightTheme,
            builder: (context, child) {
              return CupertinoTheme(
                data: CupertinoThemeData(
                  brightness:
                      provider.isDarkTheme ? Brightness.dark : Brightness.light,
                ),
                child: Material(
                  child: child,
                ),
              );
            },
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => HomePage(),
              RestaurantDetail.routeName: (context) => RestaurantDetail(
                  restaurantsId: ModalRoute.of(context).settings.arguments),
            },
          );
        },
      ),
    );
  }
}
