//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';

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
    // //  Construct hostPath.
    // //  Generate a Path variable representing the boundary of hostRect.
    // Path hostPath = Path();
    // hostPath
    //   ..addRRect(
    //       RRect.fromRectAndRadius(
    //           Offset(0.0, 0.0) & size, Radius.circular(25)));
    //
    // //  Construct guestPath.
    // //  Get [renderBox] associated with SettingsPageListTileClipper.
    // RenderBox renderBox = context.findRenderObject() as RenderBox;
    //
    // //  Get global offset associated with the top left corner of
    // //  [SettingsPageListTileClipper].
    // Offset offset = renderBox.globalToLocal(Offset(0.0, 0.0));
    //
    // //  Convert guestRect from global coordinate system to a system local to
    // //  [renderBox], which represents the current local instance of ListTile.
    // Rect localGuestRect = guestRect!.shift(offset);
    //
    // //  Generate a Path variable representing the boundary of guestRect.
    // Path guestPath = Path();
    // guestPath
    //   ..addRRect(
    //       RRect.fromRectAndRadius(localGuestRect, Radius.circular(15)));
    //
    // //  Create the clipPath by subtracting guestPath from hostPath.
    // return Path.combine(PathOperation.difference, hostPath, guestPath);

    //  Construct [hostRect] (in this instance the Rect associated with
    //  [SettingsPageListTile] in a coordinate system local to itself).
    Rect hostRect = Offset(0.0, 0.0) & size;

    //  Construct [guestRect].
    //  Get [renderBox] associated with [SettingsPageListTileClipper].
    RenderBox renderBox = context.findRenderObject() as RenderBox;

    //  Get global offset associated with the top left corner of
    //  [SettingsPageListTileClipper] relative to the top left screen corner.
    Offset offset = renderBox.globalToLocal(Offset(0.0, 0.0));

    //  Convert guestRect from the global coordinate system relative to the
    //  top left screen corner, to a system local to [renderBox], which
    //  represents the current local instance of ListTile.
    Rect localGuestRect = guestRect!.shift(offset);

    //  Check to see if hostRect and guestRect intersect. (Non-intersecting
    //  Rect variables produce a third Rect with a negative width OR height.)
    if ((hostRect.intersect(localGuestRect).width > 0) &&
        (hostRect.intersect(localGuestRect).height > 0)) {
      //  Set radius so that SettingsPageListTile transitions quickly.
      double radius = localGuestRect.shortestSide;

      //  Stretch localGuestRect vertically by an amount equal to radius.
      //  Used for detecting the start of the transition process for hostRect.
      if (AppSettings.buttonAlignment.y > 0) {
        localGuestRect = Rect.fromLTRB(
          localGuestRect.left,
          localGuestRect.top,
          localGuestRect.right,
          localGuestRect.bottom + radius,
        );
      }
      if (AppSettings.buttonAlignment.y < 0) {
        localGuestRect = Rect.fromLTRB(
          localGuestRect.left,
          localGuestRect.top - radius,
          localGuestRect.right,
          localGuestRect.bottom,
        );
      }


    }
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
