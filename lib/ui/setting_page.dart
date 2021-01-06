import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/provider/preferences_provider.dart';
import 'package:restaurant_app_flutter/provider/scheduling_provider.dart';
import 'package:restaurant_app_flutter/widget/custom_dialog.dart';

class SettingPage extends StatelessWidget {
  static const routeName = '/setting_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Consumer<PreferencesProvider>(
        builder: (context, provider, _) {
          return ListView(
            children: [
              Material(
                child: ListTile(
                  title: Text('Dark Theme'),
                  trailing: Switch.adaptive(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ),
              Material(
                child: ListTile(
                  title: Text('Schedule Restaurant'),
                  trailing: Consumer<SchedulingProvider>(
                    builder: (context, scheduled, _) {
                      return Switch.adaptive(
                        value: provider.isDailyReminderActive,
                        onChanged: (value) {
                          if (Platform.isAndroid) {
                            scheduled.scheduleNotification(value);
                            provider.enableDailyReminder(value);
                          } else {
                            customDialog(context);
                          }
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
