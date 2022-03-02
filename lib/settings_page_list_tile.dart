//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/data_notification.dart';
import 'package:kar_kam/notification_notifier.dart';

class SettingsPageListTile extends StatelessWidget {
  const SettingsPageListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable:
          NotificationNotifier.of<ScrollNotification, double>(context)
              .notificationData,
      builder: (
        BuildContext context,
        double value,
        __,
      ) {
        return Container(
          height: 20.0 + 80 * math.pow(math.cos(value / 50), 2),
          width: 50,
          alignment: Alignment.center,
          child: Text('SettingsPageListTile'),
        );
      },
    );
  }
}
