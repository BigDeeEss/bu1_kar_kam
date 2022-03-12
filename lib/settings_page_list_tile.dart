//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/global_key_extension.dart';

/// [SettingsPageListTile] is the root widget providing a single bespoke
/// ListTile instance for SettingsPageContents.
class SettingsPageListTile extends StatefulWidget {
  SettingsPageListTile({Key? key}) : super(key: key);

  @override
  _SettingsPageListTileState createState() => _SettingsPageListTileState();
}

class _SettingsPageListTileState extends State<SettingsPageListTile> {
  /// [cardGlobalKey] and the method defined in
  /// global_key_extension.dart provide the mechanism by which
  /// [SettingsPageListTileOverlayEntry] gets Rect information from the
  /// instance of Card defined below.
  final GlobalKey cardGlobalKey = GlobalKey();

  /// [SettingsPageListTileOverlayEntry] uses an overlay to create a second
  /// listTile which takes Rect data from, and sits directly over, an
  /// invisible listTile.
  /// The invisible dummy listTile is there only to provide the required
  /// positional information.
  late OverlayEntry SettingsPageListTileOverlayEntry;

  @override
  void initState() {
    super.initState() ;
    //  After build of [BackGroundListTile] initiate build of
    //  [SettingsPageListTileOverlayEntry].
    WidgetsBinding.instance!.addPostFrameCallback((_)
      => showSettingsPageListTileOverlay(context));
  }

  /// [showSettingsPageListTileOverlay] builds and inserts
  /// [SettingsPageListTileOverlayEntry] over everything representing
  /// the current UI.
  void showSettingsPageListTileOverlay(BuildContext context) {
    //  Instantiate instance of OverlayState? and
    //  SettingsPageListTileOverlayEntry.
    OverlayState? SettingsPageListTileOverlayState = Overlay.of(context);

    //  Instantiate instance of RenderBox
    //  Build [SettingsPageListTileOverlayEntry].
    SettingsPageListTileOverlayEntry = OverlayEntry(builder: (context) {
      Rect? cardRect = cardGlobalKey.globalPaintBounds;
      // Rect? buttonArrayRect = NotificationNotifier.of <DataNotification, Rect?> (context).notificationData.value;
      print('cardRect = $cardRect');
      if (cardRect != null) {
        return Positioned(
          left: cardRect.left,
          top: cardRect.top,
          width: cardRect.size.width,
          child: Card(
            child: BackGroundListTile(),
          ),
        );
      } else {
        return Container();
      }
      // return BackGroundListTile();
      // return ClipPath(
      //     clipper: SettingsPageListTileClipper(
      //       rect1: cardRect,
      //       rect2: cardRect,
      //       // rect2: buttonArrayRect,
      //     ),
      //     child: Card(
      //       child: BackGroundListTile(),
      //     )
      // );
    });
    // Insert [SettingsPageListTileOverlayEntry] into the Overlay.
    SettingsPageListTileOverlayState?.insert(SettingsPageListTileOverlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return BackGroundListTile(key: cardGlobalKey);
  }
}

class BackGroundListTile extends StatelessWidget {
  const BackGroundListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Opacity(
        opacity: 0.5,
        child: ListTile(
          leading: FlutterLogo(size: 72.0),
          title: Text('BackGroundListTile'),
          subtitle: Text(
              'Example.'
          ),
          trailing: Icon(Icons.more_vert),
        )
      )
    );
    // return Opacity(
    //     opacity: 0.5,
    //     child: ListTile(
    //       leading: FlutterLogo(size: 72.0),
    //       title: Text('BackGroundListTile'),
    //       subtitle: Text(
    //           'Example.'
    //       ),
    //       trailing: Icon(Icons.more_vert),
    //     )
    // );
  }
}

