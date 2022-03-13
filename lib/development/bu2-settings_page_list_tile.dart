//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';


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
    SettingsPageListTileOverlayEntry.dispose();
    super.dispose();
  }

  /// [removeSettingsPageListTileOverlay] cancels the overlay.
  void removeSettingsPageListTileOverlay() =>
      SettingsPageListTileOverlayEntry.remove();

  void showSettingsPageListTileOverlay(BuildContext context) {

  }

  // /// [initState] instantiates [SettingsPageListTileOverlayEntry] and defines
  // /// a post frame callback to instantiate the overlay.
  // @override
  // void initState() {
  //
  //   OverlayState? SettingsPageListTileOverlayState = Overlay.of(context);
  //   SettingsPageListTileOverlayState
  // }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showSettingsPageListTileOverlay();
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