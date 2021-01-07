import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_flutter/common/constant.dart';
import 'package:restaurant_app_flutter/provider/preferences_provider.dart';
import 'package:restaurant_app_flutter/provider/scheduling_provider.dart';
import 'package:restaurant_app_flutter/widget/custom_dialog.dart';
import 'package:restaurant_app_flutter/widget/platform_widget.dart';

class SettingPage extends StatelessWidget {
  static const title = 'Setting';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                  color: Colors.grey[900]),
              child: Center(
                child: Text(
                  title,
                  style: textStyle.copyWith(fontSize: 22),
                ),
              ),
            ),
            SizedBox(height: 72),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                    color: Color.fromRGBO(72, 85, 99, 1)),
                child: _buildList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
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

Widget _buildList() {
  Color _listColor = Color.fromRGBO(72, 85, 99, 1);
  return Consumer<PreferencesProvider>(
    builder: (context, provider, _) {
      return ListView(
        children: [
          SizedBox(height: 6),
          Center(child: Icon(Icons.menu)),
          SizedBox(height: 30),
          Divider(color: Colors.black),
          Material(
            color: _listColor,
            child: ListTile(
              title: Text(
                'Dark Theme',
                style: textStyle,
              ),
              trailing: Switch.adaptive(
                value: false,
                onChanged: (value) {},
              ),
            ),
          ),
          Divider(color: Colors.black),
          Material(
            color: _listColor,
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
                      if (Platform.isAndroid) {
                        scheduled.scheduleNotification(value);
                        provider.enableDailyReminder(value);
                      } else {
                        customDialog(context, 'Coming Soon',
                            'This feature will coming soon!');
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
