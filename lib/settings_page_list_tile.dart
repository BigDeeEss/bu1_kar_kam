//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/data_notification.dart';
import 'package:kar_kam/global_key_extension.dart';
import 'package:kar_kam/notification_notifier.dart';

/// [SettingsPageListTileGlobalKeyNotifier] implements a method for
/// [_SettingsPageListTileWithGlobalKey] to be able to access
/// [SettingsPageListTileGlobalKey] stored in it's parent class.
class SettingsPageListTileGlobalKeyNotifier extends InheritedWidget {
  const SettingsPageListTileGlobalKeyNotifier({
    Key? key,
    required this.settingsPageListTileGlobalKey,
    required Widget child,
  }) : super(key: key, child: child);

  /// [settingsPageListTileGlobalKey] is the global key passed to
  /// [_SettingsPageListTileWithGlobalKey] via it's key parameter.
  final GlobalKey settingsPageListTileGlobalKey;

  /// Default [of] method that allows [_SettingsPageListTileWithGlobalKey]
  /// to gain access to [SettingsPageListTileGlobalKey] stored in it's
  /// parent class.
  static SettingsPageListTileGlobalKeyNotifier of(BuildContext context) {
    final SettingsPageListTileGlobalKeyNotifier? result =
        context.dependOnInheritedWidgetOfExactType<
            SettingsPageListTileGlobalKeyNotifier>();
    assert(result != null,
        'No SettingsPageListTileGlobalKeyNotifier found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(SettingsPageListTileGlobalKeyNotifier old) {
    //  For the lifetime of this instance of [SettingsPageListTile] key,
    //  which is the dat stored in [SettingsPageListTileGlobalKeyNotifier]
    //  will remain unchanged.
    return false;
  }
}

class SettingsPageListTile extends StatelessWidget {
  SettingsPageListTile({Key? key}) : super(key: key);

  final GlobalKey settingsPageListTileGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SettingsPageListTileGlobalKeyNotifier(
      settingsPageListTileGlobalKey: settingsPageListTileGlobalKey,
      child: _SettingsPageListTileWithGlobalKey(
        key: settingsPageListTileGlobalKey,
      ),
    );
  }
}

class _SettingsPageListTileWithGlobalKey extends StatelessWidget {
  _SettingsPageListTileWithGlobalKey({Key? key}) : super(key: key);

  late Path? clipPath;

  Path? PathFromRect(Rect? rect) {
    Path path = Path();
    if (rect != null) {
      path.addRect(rect);
    }
    return path;
  }

  @override
  Widget build(BuildContext context) {
    clipPath = PathFromRect(
        NotificationNotifier.of<DataNotification, Rect?>(context)
            .notificationData
            .value);

    return ValueListenableBuilder<double>(
      valueListenable:
          NotificationNotifier.of<ScrollNotification, double>(context)
              .notificationData,
      builder: (
        BuildContext context,
        double value,
        __,
      ) {
        // print('_SettingsPageListTileWithGlobalKey, settingsPageListTileGlobalKey = ${SettingsPageListTileGlobalKeyNotifier.of(context)
        //     .settingsPageListTileGlobalKey}');
        GlobalKey settingsPageListTileGlobalKey = SettingsPageListTileGlobalKeyNotifier.of(context)
            .settingsPageListTileGlobalKey;
        print(settingsPageListTileGlobalKey.globalPaintBounds);
        return Card(
          child: Container(
            height: 20.0 + 80 * math.pow(math.cos(value / 50), 2),
            width: 50,
            alignment: Alignment.center,
            child: Text('SettingsPageListTile'),
            color: Colors.tealAccent,
          ),
        );
      },
    );
  }
}
