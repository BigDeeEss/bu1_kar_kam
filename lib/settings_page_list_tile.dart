//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/clipped_rounded_rectangle_border.dart';
import 'package:kar_kam/data_notification.dart';
import 'package:kar_kam/global_key_extension.dart';
import 'package:kar_kam/notification_notifier.dart';

import 'development/rounded_rectangle_border.dart';

class SettingsPageListTile extends StatefulWidget {
  SettingsPageListTile({
    Key? key,
    this.color,
    this.opacity,
    this.text,
  }) : super(key: key);

  final Color? color;
  final double? opacity;
  final String? text;

  @override
  State<SettingsPageListTile> createState() => SettingsPageListTileState();
}

class SettingsPageListTileState extends State<SettingsPageListTile> {
  final GlobalKey globalKey = GlobalKey();

  Rect? rect = null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      rect = globalKey.globalPaintBounds;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('build, size = ${MediaQuery.of(context).size}');
    return ValueListenableBuilder(
      valueListenable: NotificationNotifier.of <ScrollNotification, double> (context).notificationData,
      builder: (BuildContext context, double value, __,){
        // print(value/10 % 50 + 10);
        // print('globalKey $globalKey');
        // print('guestRect = ${NotificationNotifier.of <DataNotification, Rect?> (context).notificationData.value}');
        return Card(
          shape: ClippedRoundedRectangleBorder(
          // shape: RRoundedRectangleBorder(
            borderRadius: BorderRadius.circular(value/10 % 50 + 10),
            guestRect: NotificationNotifier.of <DataNotification, Rect?> (context).notificationData.value,
          ),
          elevation: value,
          key: globalKey,
          color: widget.color,
          child: ListTile(
            leading: FlutterLogo(size: 72.0),
            title: Text('SettingsPageListTile'),
            subtitle: Text(widget.text ?? ''),
            trailing: Icon(Icons.more_vert),
          ),
        );
      },
    );
  }
}
