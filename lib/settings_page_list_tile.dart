//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/global_key_extension.dart';
import 'package:kar_kam/notification_notifier.dart';

/// [SettingsPageListTile] is the root widget providing a single bespoke
/// ListTile instance for SettingsPageContents.
class SettingsPageListTile extends StatefulWidget {
  SettingsPageListTile({Key? key}) : super(key: key);

  @override
  _SettingsPageListTileState createState() => _SettingsPageListTileState();
}

class _SettingsPageListTileState extends State<SettingsPageListTile> {
  /// [globalKey] and the method defined in global_key_extension.dart
  /// provide the mechanism by which the secondary instance of 
  /// [BackgroundListTile] within [overlayEntry] gets Rect information
  /// from the primary instance of [BackgroundListTile].
  /// 
  /// The build method associated with [_SettingsPageListTileState]
  /// builds the primary [BackgroundListTile].
  final GlobalKey globalKey = GlobalKey();

  /// [layerLink] links the primary and secondary [BackgroundListTile]
  /// instances.
  final layerLink = LayerLink();

  /// [overlayEntry] uses an overlay to create a secondary instance of
  /// [BackgroundListTile] which takes Rect data from, and sits directly over,
  /// a primary instance of [BackgroundListTile] controlled by ListView.
  late OverlayEntry overlayEntry;
  
  /// [overlayState] is the overlay produced by [SettingsPageListTile].
  late OverlayState overlayState;

  @override
  void dispose() {
    // Without the following [cardRect] within [showOverlay] can be null.
    overlayEntry.remove();
    // overlayEntry.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState() ;
    //  After build of primary [BackgroundListTile] build [overlayEntry].
    WidgetsBinding.instance!.addPostFrameCallback((_)
      => showOverlay(context));
  }

  /// [showOverlay] builds and inserts [overlayEntry]
  /// over everything representing the current UI.
  void showOverlay(BuildContext context) {
    //  Instantiate [o]verlayState].
    overlayState = Overlay.of(context)!;

    //  Instantiate [overlayEntry].
    overlayEntry = OverlayEntry(builder: (context) {
      Rect? cardRect = globalKey.globalPaintBounds;
      // Rect? buttonArrayRect = NotificationNotifier.of <DataNotification, Rect?> (context).notificationData.value;
      // print(NotificationNotifier.of <ScrollNotification, double> (context).notificationData);
      // print('cardRect = $cardRect');
      // print('cardRect.size = ${cardRect!.size}');
      // print('cardRect.size.width = ${cardRect.size.width}');
      if (cardRect != null) {
        return Positioned(
          width: cardRect.size.width,
          height: cardRect.size.height,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, cardRect.size.height + 10),
            child: BackgroundListTile(color: Colors.blueGrey, opacity: 0.5,),
          ),
        );
      } else {
        return Container();
      }
    });
    // Insert [overlayEntry] into the [overlayState].
    overlayState.insert(overlayEntry);
  }

  //  Build primary instance of [BackgroundListTile]. Note that only this 
  //  instance takes [globalKey] as input. Note also [layerLink] and the
  //  use of CompositedTransformTarget(...).
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: BackgroundListTile(
        key: globalKey,
        color: Colors.lightGreen,
        opacity: 1.0,
      ),
    );
  }
}

class BackgroundListTile extends StatelessWidget {
  BackgroundListTile({
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
            title: Text('BackgroundListTile'),
            subtitle: Text('Example: $color, ${opacity}'),
            trailing: Icon(Icons.more_vert),
            tileColor: color
          ),
        ),
      ),
    );
  }
}

