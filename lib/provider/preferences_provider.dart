import 'package:flutter/cupertino.dart';
import 'package:restaurant_app_flutter/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  final PreferencesHelper preferencesHelper;

  PreferencesProvider({@required this.preferencesHelper}) {
    _getDailyNewsPreferences();
  }

  bool _isDailyReminderActive = false;
  bool get isDailyReminderActive => _isDailyReminderActive;

  void _getDailyNewsPreferences() async {
    _isDailyReminderActive = await preferencesHelper.isDailyReminderActive;
  }

  void enableDailyReminder(bool value) {
    preferencesHelper.setDailyNews(value);
    _getDailyNewsPreferences();
  }
}
