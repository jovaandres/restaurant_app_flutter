import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/common/constant.dart';

class CustomAppBar extends PreferredSize {
  final double height;
  final Function onPressed;

  CustomAppBar({this.height = kToolbarHeight, @required this.onPressed});

  @override
  Size get preferredSize => Size.fromHeight(height + 34);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: preferredSize.height,
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Restaurant',
                  style: textStyle.copyWith(fontSize: 24),
                ),
                Text(
                  'Recommendation restaurant for you!',
                  style: textStyle.copyWith(
                      fontSize: 14, fontWeight: FontWeight.bold),
                )
              ],
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: onPressed,
            )
          ],
        ),
      ),
    );
  }
}
