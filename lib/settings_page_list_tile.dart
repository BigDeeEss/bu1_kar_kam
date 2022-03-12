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
  /// [settingsPageListTileGlobalKey] and the method defined in
  /// global_key_extension.dart provide the mechanism by which
  /// [SettingsPageListTileOverlayEntry] gets Rect information from the
  /// instance of Card defined below.
  final GlobalKey settingsPageListTileGlobalKey = GlobalKey();

  /// [settingsPageListTileLayerLink] is the object which links
  /// [SettingsPageListTileOverlayEntry] with [BackGroundListTile].
  final settingsPageListTileLayerLink = LayerLink();

  /// [SettingsPageListTileOverlayEntry] uses an overlay to create a second
  /// listTile which takes Rect data from, and sits directly over, an
  /// invisible listTile.
  /// The invisible dummy listTile is there only to provide the required
  /// positional information.
  late OverlayEntry SettingsPageListTileOverlayEntry;

  @override
  void dispose() {
    // Solves my null problem associated with cardRect.
    SettingsPageListTileOverlayEntry.remove();
    // SettingsPageListTileOverlayEntry.dispose();
    super.dispose();
  }

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
    //  Instantiate instance of OverlayState and
    //  SettingsPageListTileOverlayEntry.
    OverlayState SettingsPageListTileOverlayState = Overlay.of(context)!;

    //  Instantiate instance of RenderBox
    //  Build [SettingsPageListTileOverlayEntry].
    SettingsPageListTileOverlayEntry = OverlayEntry(builder: (context) {
      Rect? cardRect = settingsPageListTileGlobalKey.globalPaintBounds;
      // Rect? buttonArrayRect = NotificationNotifier.of <DataNotification, Rect?> (context).notificationData.value;
      print('cardRect = $cardRect');
      // print('cardRect.size = ${cardRect!.size}');
      // print('cardRect.size.width = ${cardRect.size.width}');
      if (cardRect != null) {
        return Positioned(
          width: cardRect.size.width,
          height: cardRect.size.height,
          child: CompositedTransformFollower(
            link: settingsPageListTileLayerLink,
            showWhenUnlinked: false,
            offset: Offset(0, cardRect.size.height + 100),
            child: BackGroundListTile(color: Colors.blueGrey, opacity: 0.5,),
          ),
        );
      } else {
        return Container();
      }
    });
    // Insert [SettingsPageListTileOverlayEntry] into the Overlay.
    SettingsPageListTileOverlayState.insert(SettingsPageListTileOverlayEntry);
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
    link: settingsPageListTileLayerLink,
    child: BackGroundListTile(
      key: settingsPageListTileGlobalKey,
      color: Colors.lightGreen,
      opacity: 1.0,
    ),
  );
}

class BackGroundListTile extends StatelessWidget {
  BackGroundListTile({
    Key? key,
    required this.color,
    required this.opacity,
  })  : assert(opacity.abs() <= 1.0),
        super(key: key);

  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Material(
        child: Card(
          child: ListTile(
            leading: FlutterLogo(size: 72.0),
            title: Text('BackGroundListTile'),
            subtitle: Text('Example: $color, ${opacity}'),
            trailing: Icon(Icons.more_vert),
            tileColor: color
          ),
        ),
      ),
    );
  }
}

