//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/lib/rect_extension.dart';

/// [SettingsPageListTileClipper] calculates the path to clip against when
/// constructing SettingsPageListTile.
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
    //  Get upperConstructRect, the rect within which the upper portion of
    //  the clip path to apply to [SettingsPageListTile], is calculated.
    Rect upperConstructRect = getUpperConstructRect(size);

    //  Get topLeftClipPath, the topleft portion of the clip path to apply
    //  to [SettingsPageListTile]
    Path topLeftClipPath = getTopLeftClipPathFromRect(upperConstructRect);

    return Path()..addRRect(RRect.fromRectAndRadius(
        (Offset(0.0, 0.0) & size).inflate(-10.0), Radius.circular(25)));

    // //  Check to see if hostRect and a stretched version of guestRect
    // //  intersect. (Non-intersecting Rect variables produce a third Rect
    // //  with a negative width OR height.)
    // Rect intersectingRect =
    // hostRect.intersect(localGuestRect.inflateHeight(radius));
    // if ((intersectingRect.width > 0) && (intersectingRect.height > 0)) {
    //   //  Rects hostRect and localGuestRect intersect.
    //   //  Get height associated with intersecting Rect.
    //   double height = intersectingRect.height;
    //   // double hostLength = getHostLength(height);
    //   double hostLength = 20;
    //
    //   size = Size(size.width - hostLength, size.height);
    //   hostRect = Offset(hostLength, 0.0) & size;
    //   Path hostPath = Path();
    //   return hostPath
    //     ..addRRect(RRect.fromRectAndRadius(
    //         Offset(hostLength, 0.0) & size, Radius.circular(25)));
    // } else {
    //   Path hostPath = Path();
    //   return hostPath
    //     ..addRRect(RRect.fromRectAndRadius(
    //         Offset(0.0, 0.0) & size, Radius.circular(25)));
    // }
  }

  Rect getUpperConstructRect(Size size) {
    //  Construct [hostRect] (in this instance the Rect associated with
    //  [SettingsPageListTile] in a coordinate system local to itself).
    Rect hostRect = Offset(0.0, 0.0) & size;

    //  Construct [guestRect].
    //  Get [renderBox] associated with [SettingsPageListTileClipper].
    RenderBox renderBox = context.findRenderObject() as RenderBox;

    //  Get global offset associated with the top left corner of
    //  [SettingsPageListTile] relative to the top left screen corner.
    Offset offset = renderBox.globalToLocal(Offset(0.0, 0.0));

    //  Convert guestRect from the global coordinate system relative to the
    //  top left screen corner, to a system local to [renderBox], which
    //  represents the current local instance of ListTile.
    Rect localGuestRect = guestRect!.shift(offset);

    //  Expand [localGuestRect] in order to be able to reuse and apply
    //  [getUpperClipPathFromRect].
    if (AppSettings.buttonAlignment.x < 0) {
      localGuestRect = localGuestRect.inflateLeft(localGuestRect.width);
    }
    if (AppSettings.buttonAlignment.x > 0) {
      localGuestRect = localGuestRect.inflateRight(localGuestRect.width);
    }

    //  Return the rect within which the upper portion of
    //  the clip path to apply to [SettingsPageListTile] is calculated.
    return Offset(0.0, -localGuestRect.shortestSide)
        & Size(localGuestRect.width, localGuestRect.shortestSide);
  }

  /// [getTopLeftClipPathFromRect] calculates the top left clip path.
  /// Paths for a=other alignments are obtained via a transform at the end.
  Path getTopLeftClipPathFromRect(Rect rect) {
    //  P0 coordinates.
    //
    //  P0 is the centre of [rect] which lies on top of ButtonArray,
    //  is of twice the width as ButtonArray, and has a centre that is
    //  located at the left or right screen edge.
    Offset p0 = rect.center;

    //  P1 coordinates.
    //
    //  P1 is the point where the curved and straight portions of [clipPath]
    //  are joined. Initialised to zero, this function establishes p1 later on.
    Offset p1 = Offset.zero;

    //  P2 coordinates.
    //
    //  P2 is the Bezier construction point for the curved part of [clipPath].
    //  Initialised to zero, this function establishes p2 later on.
    Offset p2 = Offset.zero;

    //  P3 coordinates,
    //
    //  P3 is the bottom left/right corner of [rect] displaced downwards
    //  by distance equal to half of rect.height.
    Offset p3 = rect.bottomLeft.translate(0.0, 0.5 * rect.size.height);

    //  Update p2 with the correct offset.
    double tmp1 = 9 * p3.dy - p0.dy;
    double tmp2 = p3.dy - p0.dy;
    double tmp3 = p3.dx - p0.dx;
    p2 = Offset(p3.dx, (tmp1 - math.sqrt(9 * tmp2 * tmp2 + 8 * tmp3 * tmp3)) / 8.0);

    //  P1 coordinates.
    return Path();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
