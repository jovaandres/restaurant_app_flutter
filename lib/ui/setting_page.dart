import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/common/constant.dart';
import 'package:restaurant_app_flutter/provider/preferences_provider.dart';
import 'package:restaurant_app_flutter/provider/scheduling_provider.dart';
import 'package:restaurant_app_flutter/widget/custom_android_app_bar.dart';
import 'package:restaurant_app_flutter/widget/custom_dialog.dart';
import 'package:restaurant_app_flutter/widget/platform_widget.dart';
import 'package:restaurant_app_flutter/common/custom_color_scheme.dart';

class SettingPage extends StatefulWidget {
  static const title = 'Setting';

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool boolean = false;

  Widget _buildList() {
    ;
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        return ListView(
          children: [
            SizedBox(height: 6),
            Center(child: Icon(Icons.menu)),
            SizedBox(height: 30),
            Divider(color: Colors.black),
            Material(
              color: Theme.of(context).colorScheme.settingPadColor,
              child: ListTile(
                title: Text(
                  'Dark Theme',
                  style: textStyle,
                ),
                trailing: Switch.adaptive(
                  value: provider.isDarkTheme,
                  onChanged: (value) => provider.enableDarkTheme(value),
                ),
              ),
            ),
            Divider(color: Colors.black),
            Material(
              color: Theme.of(context).colorScheme.settingPadColor,
              child: ListTile(
                title: Text(
                  'Schedule Restaurant',
                  style: textStyle,
                ),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return Switch.adaptive(
                      value: provider.isDailyReminderActive,
                      onChanged: (value) {
                        if (Platform.isIOS) {
                          customDialog(context, 'Coming Soon',
                              'This feature will coming soon!');
                        } else {
                          scheduled.scheduleNotification(value);
                          provider.enableDailyReminder(value);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            Divider(color: Colors.black),
          ],
        );
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: CustomAndroidAppBar(
        child: Center(
          child: Text(
            SettingPage.title,
            style: textStyle.copyWith(fontSize: 22),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 72),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                  color: Theme.of(context).colorScheme.settingPadColor),
              child: _buildList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(SettingPage.title),
      ),
      child: _buildList(),
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
