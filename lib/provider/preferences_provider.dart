import 'package:flutter/cupertino.dart';
import 'package:restaurant_app_flutter/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  final PreferencesHelper preferencesHelper;

  PreferencesProvider({@required this.preferencesHelper}) {
    _getDailyNewsPreferences();
    _getThemePreferences();
  }

  bool _isDailyReminderActive = false;
  bool get isDailyReminderActive => _isDailyReminderActive;

  bool _isDarkTheme = true;
  bool get isDarkTheme => _isDarkTheme;

  void _getDailyNewsPreferences() async {
    _isDailyReminderActive = await preferencesHelper.isDailyReminderActive;
    notifyListeners();
  }

  void enableDailyReminder(bool value) {
    preferencesHelper.setDailyNews(value);
    _getDailyNewsPreferences();
  }

  void _getThemePreferences() async {
    _isDarkTheme = await preferencesHelper.isDarkTheme;
    notifyListeners();
  }

  void enableDarkTheme(bool value) {
    preferencesHelper.setDarkTheme(value);
    _getThemePreferences();
  }
}
