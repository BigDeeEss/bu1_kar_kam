//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kar_kam/data_notification.dart';
import 'package:kar_kam/global_key_extension.dart';
import 'package:kar_kam/notification_notifier.dart';
import 'package:kar_kam/settings_page_list_tile_clipper.dart';


/// [SettingsPageListTile] is the root widget providing a single bespoke
/// ListTile instance for SettingsPageContents.
class SettingsPageListTile extends StatefulWidget {
  SettingsPageListTile({Key? key}) : super(key: key);

  @override
  State<SettingsPageListTile> createState() => _SettingsPageListTileState();
}

class _SettingsPageListTileState extends State<SettingsPageListTile> {
  /// [cardGlobalKey], and the method defined in
  /// global_key_extension.dart, provides the mechanism by which
  /// [SettingsPageListTileOverlayEntry] gets Rect information from the
  /// instance of Card defined below.
  final GlobalKey cardGlobalKey = GlobalKey();

  /// [overlayEntry], an instance of OverlayEntry, uses overlays to
  /// create a second listTile which takes Rect data from, and sits directly
  /// over, an opaque listTile that provides positional information.
  late OverlayEntry SettingsPageListTileOverlayEntry;

  @override
  void dispose() {
    // removeSettingsPageListTileOverlay();
    SettingsPageListTileOverlayEntry.remove();
    SettingsPageListTileOverlayEntry.dispose();
    super.dispose();
  }

  void showSettingsPageListTileOverlay(BuildContext context) {
    //  Instantiate instance of OverlayState? and
    //  SettingsPageListTileOverlayEntry.
    OverlayState? SettingsPageListTileOverlayState = Overlay.of(context);
    SettingsPageListTileOverlayEntry = OverlayEntry(builder: (context) {
      Rect? cardRect = cardGlobalKey.globalPaintBounds;
      Rect? buttonArrayRect = NotificationNotifier.of <DataNotification, Rect?> (context).notificationData.value;
      print('cardRect = $cardRect');
      return ClipPath(
        clipper: SettingsPageListTileClipper(
          rect1: cardRect,
          rect2: buttonArrayRect,
        ),
        child: Card(
          child: testTile,
        )
      );
    });
    // Inserting the [SettingsPageListTileOverlayEntry] into the Overlay.
    SettingsPageListTileOverlayState?.insert(SettingsPageListTileOverlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showSettingsPageListTileOverlay(context);
    });
    return Opacity(
        opacity: 0.5,
        child: Card(
            key: cardGlobalKey,
            child: testTile
        )
    );
  }
}


const testTile = ListTile(
  leading: FlutterLogo(size: 72.0),
  title: Text('SettingsPageListTile'),
  subtitle: Text(
      'A sufficiently long subtitle warrants three lines.'
  ),
  trailing: Icon(Icons.more_vert),
  isThreeLine: true,
);