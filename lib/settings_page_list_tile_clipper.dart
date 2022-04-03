//  Import flutter packages.
import 'package:flutter/material.dart';

/// [SettingsPageListTileClipper] calculates the path to clip against when
/// constructing SettinsgPageListTile.
class SettingsPageListTileClipper extends CustomClipper<Path> {
  const SettingsPageListTileClipper({
    required this.context,
    required this.guestRect,
    Listenable? reclip,
  }) : super(reclip: reclip);

  /// [guestRect] is the Rect which [SettingsPageListTileClipper] creates
  /// a path to avoid.
  final Rect? guestRect;

  //  Required on order to find the current renderBox.
  final BuildContext context;

  @override
  Path getClip(Size size) {
    //  Get [renderBox] associated with SettingsPageListTileClipper.
    RenderBox renderBox = context.findRenderObject() as RenderBox;

    //  Get global offset associated with the top left corner of
    //  [SettingsPageListTileClipper].
    Offset offset = renderBox.globalToLocal(Offset(0.0, 0.0));

    //  Convert guestRect from global coordinate system to a system local to
    //  [renderBox], which represents the currunt local instance of ListTile.
    Rect localGuestRect = guestRect!.shift(offset);

    //  Generate a Path variable representing the boundary of hostRect.
    Path hostPath = Path();
    hostPath..addRRect(
        RRect.fromRectAndRadius(Offset(0.0, 0.0) & size, Radius.circular(25)));

    //  Generate a Path variable representing the boundary of guestRect.
    Path guestPath = Path();
    guestPath..addRRect(
        RRect.fromRectAndRadius(localGuestRect, Radius.circular(15)));

    //  Create the clipPath by subtracting guestPath from hostPath.
    return Path.combine(PathOperation.difference, hostPath, guestPath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
