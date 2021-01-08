import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String message;

  EmptyWidget({@required this.message});

  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 350,
      child: EmptyListWidget(
        image: null,
        packageImage: PackageImage.Image_4,
        title: 'Nothing Found Here',
        subTitle: message,
        titleTextStyle: Theme.of(context)
            .typography
            .dense
            .headline5
            .copyWith(color: Color(0xff9da9c7)),
        subtitleTextStyle: Theme.of(context)
            .typography
            .dense
            .headline6
            .copyWith(color: Color(0xffabb8d6)),
      ),
    );
  }
}
