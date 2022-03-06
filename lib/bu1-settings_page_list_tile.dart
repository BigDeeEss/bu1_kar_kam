//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/global_key_extension.dart';
import 'package:kar_kam/notification_notifier.dart';
import 'package:kar_kam/settings_page_list_tile_clipper.dart';


/// [_SettingsPageListTileGlobalKeyNotifier] implements a method for
/// [_SettingsPageListTileWithGlobalKey] to be able to access
/// [SettingsPageListTileGlobalKey] stored in it's parent class.
class _SettingsPageListTileGlobalKeyNotifier extends InheritedWidget {
  const _SettingsPageListTileGlobalKeyNotifier({
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
  static _SettingsPageListTileGlobalKeyNotifier of(BuildContext context) {
    final _SettingsPageListTileGlobalKeyNotifier? result =
        context.dependOnInheritedWidgetOfExactType<
            _SettingsPageListTileGlobalKeyNotifier>();
    assert(result != null,
        'No _SettingsPageListTileGlobalKeyNotifier found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_SettingsPageListTileGlobalKeyNotifier old) {
    //  For the lifetime of this instance of [SettingsPageListTile] key,
    //  which is the dat stored in [_SettingsPageListTileGlobalKeyNotifier]
    //  will remain unchanged.
    return false;
  }
}

class SettingsPageListTile extends StatelessWidget {
  SettingsPageListTile({
    Key? key,
    required this.buttonArrayRect
  }) : super(key: key);

  final GlobalKey settingsPageListTileGlobalKey = GlobalKey();

  final Rect? buttonArrayRect;

  @override
  Widget build(BuildContext context) {
    return _SettingsPageListTileGlobalKeyNotifier(
      settingsPageListTileGlobalKey: settingsPageListTileGlobalKey,
      child: _SettingsPageListTileWithGlobalKey(
        key: settingsPageListTileGlobalKey,
        buttonArrayRect: buttonArrayRect,
      ),
    );
  }
}

class _SettingsPageListTileWithGlobalKey extends StatelessWidget {
  _SettingsPageListTileWithGlobalKey({
    Key? key,
    required this.buttonArrayRect,
  }) : super(key: key);

  final Rect? buttonArrayRect;

  @override
  Widget build(BuildContext contzext) {
    // clipPath = PathFromRect(
    //     NotificationNotifier.of<DataNotification, Rect?>(context)
    //         .notificationData
    //         .value);

    return ValueListenableBuilder<double>(
      valueListenable:
          NotificationNotifier.of<ScrollNotification, double>(context)
              .notificationData,
      builder: (
        BuildContext context,
        double value,
        __,
      ) {
        // print('_SettingsPageListTileWithGlobalKey, settingsPageListTileGlobalKey = ${_SettingsPageListTileGlobalKeyNotifier.of(context)
        //     .settingsPageListTileGlobalKey}');
        GlobalKey settingsPageListTileGlobalKey =
            _SettingsPageListTileGlobalKeyNotifier.of(context)
                .settingsPageListTileGlobalKey;
        Rect? listTileRect = settingsPageListTileGlobalKey.globalPaintBounds;
        return ClipPath(
          clipper: _SettingsPageListTileShape(
            rect1: listTileRect,
            rect2: buttonArrayRect,
          ),
          child: Container(
            height: 20.0 + 80 * math.pow(math.cos(value / 50), 2),
            width: 50,
            alignment: Alignment.center,
            child: Text('SettingsPageListTile'),
            color: Colors.tealAccent,
          ),
        );
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

class _SettingsPageListTileWithGlobalKeyState extends State<_SettingsPageListTileWithGlobalKey> {
  // late Path? clipPath;

  // Rect? listTileRect = settingsPageListTileGlobalKey.globalPaintBounds;

  @override
  Widget build(BuildContext context) {
    // clipPath = PathFromRect(
    //     NotificationNotifier.of<DataNotification, Rect?>(context)
    //         .notificationData
    //         .value);


    WidgetsBinding.instance!.addPostFrameCallback((_) {

    });


    return ValueListenableBuilder<double>(
      valueListenable:
          NotificationNotifier.of<ScrollNotification, double>(context)
              .notificationData,
      builder: (
        BuildContext context,
        double value,
        __,
      ) {
        // print('_SettingsPageListTileWithGlobalKey, settingsPageListTileGlobalKey = ${_SettingsPageListTileGlobalKeyNotifier.of(context)
        //     .settingsPageListTileGlobalKey}');
        GlobalKey settingsPageListTileGlobalKey =
            _SettingsPageListTileGlobalKeyNotifier.of(context)
                .settingsPageListTileGlobalKey;
        Rect? listTileRect = settingsPageListTileGlobalKey.globalPaintBounds;
        return ClipPath(
          clipper: SettingsPageListTileClipper(
            rect1: listTileRect,
            rect2: widget.buttonArrayRect,
          ),
          child: Container(
            height: 20.0 + 80 * math.pow(math.cos(value / 50), 2),
            width: 50,
            alignment: Alignment.center,
            child: Text('SettingsPageListTile'),
            color: Colors.tealAccent,
          ),
        );
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
