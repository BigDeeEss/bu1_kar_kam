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
    required this.index,
  }) : super(key: key);

  final int index;

  late Rect buttonArrayRect;

  @override
  Widget build(BuildContext context) {
    //  Retrieve buttonArrayRect from DataNotifier further up the widget tree.
    buttonArrayRect =
        DataNotifier.of(context, ValueKey('buttonArrayRect')).data.value;
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
    );
  }
}
