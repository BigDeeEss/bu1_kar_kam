//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/lib/rect_extension.dart';

class ListViewBuilderSettingsPageListTile extends StatelessWidget {
  ListViewBuilderSettingsPageListTile({
    Key? key,
    required int index,
    required Rect buttonArrayRect,
    required double width,
  }) : super(key: key) {
    this.buttonArrayRect = buttonArrayRect;
    this.index = index;
    this.width = width;
    this.position = height * index;
  }

  int index = 0;
  int position = 0;
  int height = 100;
  double width = 0;
  Rect? buttonArrayRect;
  // late Rect buttonArrayRect;

  // static int set position (int index) {
  //   return this.height * index;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      //  Draw bounding box around [SettingsPageListTile].
      decoration: BoxDecoration(
        border: AppSettings.drawLayoutBounds
            ? Border.all(width: 0.0, color: Colors.redAccent)
            : null,
      ),
      margin: EdgeInsets.only(left: 0),
      height: 75,
      child: Container(
        key: UniqueKey(),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Text('Test...$index'),
      ),
    );
  }
}
