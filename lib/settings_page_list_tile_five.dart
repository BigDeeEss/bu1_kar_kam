//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/lib/global_key_extension.dart';

// Import project-specific files.

/// [SettingsPageListTileFive] is the root widget providing a single bespoke
/// ListTile instance for SettingsPageContents.
class SettingsPageListTileFive extends StatefulWidget {
  SettingsPageListTileFive({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  _SettingsPageListTileFiveState createState() =>
      _SettingsPageListTileFiveState();
}

class _SettingsPageListTileFiveState extends State<SettingsPageListTileFive> {
  /// [globalKey] and the method defined in global_key_extension.dart
  /// provide the mechanism by which the secondary instance of
  /// [BackgroundListTile] within [overlayEntry] gets Rect information
  /// from the primary instance of [BackgroundListTile].
  ///
  /// The build method associated with [_SettingsPageListTileFiveState]
  /// builds the primary [BackgroundListTile].
  final GlobalKey globalKey = GlobalKey();

  /// [layerLink] links the primary and secondary [BackgroundListTile]
  /// instances.
  final layerLink = LayerLink();

  /// [overlayEntry] uses an overlay to create a secondary instance of
  /// [BackgroundListTile] which takes Rect data from, and sits directly over,
  /// a primary instance of [BackgroundListTile] controlled by ListView.
  late OverlayEntry overlayEntry;

  /// [overlayState] is the overlay produced by [SettingsPageListTileFive].
  late OverlayState overlayState;

  late ValueNotifier<double> scrollNotificationNotifier;

  @override
  void dispose() {
    // Without the following [cardRect] within [showOverlay] can be null.
    overlayEntry.remove();
    // overlayEntry.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //  After build of primary [BackgroundListTile] build [overlayEntry].
    WidgetsBinding.instance!.addPostFrameCallback((_) => showOverlay(context));
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
            // offset: Offset(0, cardRect.size.height + 10),
            child: BackgroundListTile(
              color: Colors.blueGrey,
              opacity: 0.5,
              text: 'Secondary BackgroundListTile' + (widget.title ?? '') + '...',
              // clipper: SettingsPageListTileFiveClipper(
              //   rect1: cardRect,
              //   rect2: NotificationNotifier.of <DataNotification, Rect?> (context).notificationData.value,
              // ),
              // ToDo: get rect data into  SettingsPageListTileFiveClipper and write SettingsPageListTileFiveClipper.
            ),
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
    //  Important that [scrollNotificationNotifier] is defined separately
    //  as its null value is used as a switch in [BackgroundListTile].
    scrollNotificationNotifier =
        DataNotifier.of(context, ValueKey('scrollController')).data;
    return CompositedTransformTarget(
      link: layerLink,
      child: BackgroundListTile(
        key: globalKey,
        color: Colors.lightGreen,
        listenable: scrollNotificationNotifier,
        opacity: 1.0,
        text: 'Primary BackgroundListTile...',
      ),
    );
  }
}

class BackgroundListTile extends StatelessWidget {
  BackgroundListTile({
    Key? key,
    this.clipper,
    required this.color,
    this.listenable,
    required this.opacity,
    this.text,
  })  : assert(opacity.abs() <= 1.0),
        super(key: key);

  final CustomClipper<Path>? clipper;
  final Color color;
  final double opacity;
  final ValueNotifier<double>? listenable;
  final String? text;

  Widget buildChild() {
    return Opacity(
      opacity: opacity,
      child: Material(
        child: Card(
          child: ListTile(
              leading: FlutterLogo(),
              title: Text('BackgroundListTile'),
              subtitle: Text(text ?? ''),
              trailing: Icon(Icons.more_vert),
              tileColor: color),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (listenable != null) {
      return ValueListenableBuilder<double>(
        valueListenable: listenable!,
        builder: (
          BuildContext context,
          double value,
          __,
        ) {
          // print(value);
          return buildChild();
        },
      );
    } else {
      return buildChild();
    }
  }
}
