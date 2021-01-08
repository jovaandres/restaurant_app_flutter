import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({@required this.sharedPreferences});

  static const DARK_THEME = 'DARK_THEME';
  static const DAILY_REMINDER = 'DAILY_REMINDER';
  static const READ_NOTICE = 'READ_NOTICE';

  Future<bool> get isDarkTheme async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DARK_THEME) ?? true;
  }

  void setDarkTheme(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DARK_THEME, value);
  }

  Future<bool> get isDailyReminderActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DAILY_REMINDER) ?? false;
  }

  void setDailyNews(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DAILY_REMINDER, value);
  }

  Future<bool> get isNoticeRead async {
    final prefs = await sharedPreferences;
    return prefs.getBool(READ_NOTICE) ?? false;
  }

  void readNotice() async {
    final prefs = await sharedPreferences;
    prefs.setBool(READ_NOTICE, true);
  }
}
