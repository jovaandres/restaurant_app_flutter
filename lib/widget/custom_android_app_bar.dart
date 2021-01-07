import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/common/custom_color_scheme.dart';

class CustomAndroidAppBar extends PreferredSize {
  final Widget child;
  final double height;

  CustomAndroidAppBar({@required this.child, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
            color: Theme.of(context).colorScheme.customAppBarColor),
        child: child,
      ),
    );
  }
}
