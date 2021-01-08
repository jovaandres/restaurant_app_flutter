import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/common/navigation.dart';

customDialog(BuildContext context, String title, String content) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigation.back();
              },
            )
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            content,
            textAlign: TextAlign.center,
          ),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigation.back();
              },
            )
          ],
        );
      },
    );
  }
}
