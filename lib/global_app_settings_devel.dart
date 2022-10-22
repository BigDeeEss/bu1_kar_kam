//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/lib/data_notification.dart';
import 'package:kar_kam/lib/notification_notifier.dart';

class GlobalAppSettingsDevel extends StatefulWidget {
  GlobalAppSettingsDevel({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  ValueNotifier<_GlobalAppSettingsDevel> globalAppSettingsDevel =
      ValueNotifier(_GlobalAppSettingsDevel());

  @override
  State<GlobalAppSettingsDevel> createState() => _GlobalAppSettingsDevelState();
}

class _GlobalAppSettingsDevelState extends State<GlobalAppSettingsDevel> {
  @override
  Widget build(BuildContext context) {
    NotificationNotifier<DataNotification, _GlobalAppSettingsDevel>
        notificationNotifier = NotificationNotifier<DataNotification, _GlobalAppSettingsDevel>(
      child: widget.child,
      notificationData: widget.globalAppSettingsDevel,
      onNotification: (notification) {
        print('Test dispatch method---_GlobalAppSettingsDevelState...complete');
        return true;
      },
    );
    return widget.child;
  }
}

class _GlobalAppSettingsDevel {
  /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
  ///
  /// Used for debugging widget screen location.
  bool drawLayoutBoundsVal = true;
}
