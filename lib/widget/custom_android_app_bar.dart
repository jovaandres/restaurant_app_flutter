import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            color: Colors.grey[900]),
        child: child,
      ),
    );
  }
}
