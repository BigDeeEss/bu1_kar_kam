//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/lib/rect_extension.dart';

/// [SettingsPageListTileClipper] calculates the path to clip against when
/// constructing [SettingsPageListTile].
class SettingsPageListTileClipper extends CustomClipper<Path> {
  const SettingsPageListTileClipper({
    required this.context,
    required this.guestRect,
    Listenable? reclip,
  }) : super(reclip: reclip);

  /// [guestRect] is the Rect which [SettingsPageListTileClipper] creates
  /// a path to avoid.
  final Rect? guestRect;

  //  Required in order to find the current [renderBox]. From [renderBox] the
  //  Rect that bounds the current [SettingsPageListTile] is obtained.
  final BuildContext context;

  @override
  Path getClip(Size size) {
    //  Get upperConstructRect, the rect within which the upper portion of
    //  the clip path to apply to [SettingsPageListTile], is calculated.
    Rect upperConstructRect = getUpperConstructRect(size);

    //  Get topLeftClipPath, the topleft portion of the clip path to apply
    //  to [SettingsPageListTile]
    Path topLeftClipPath = getTopLeftClipPathFromRect(upperConstructRect);
    return Path()..addRect(upperConstructRect);
  }

  Rect getUpperConstructRect(Size size) {
    //  Construct [hostRect] (in this instance the Rect associated with
    //  [SettingsPageListTile] in a coordinate system local to itself).
    Rect hostRect = Offset(0.0, 0.0) & size;
    print('hostRect = $hostRect');

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

    //  Construct getUpperConstructRect.
    return Offset(localGuestRect.left,
            localGuestRect.top - localGuestRect.shortestSide) &
        Size(localGuestRect.width, 1.5 * localGuestRect.shortestSide);
  }

  /// [getTopLeftClipPathFromRect] calculates the top left clip path.
  /// Paths for a=other alignments are obtained via a transform at the end.
  Path getTopLeftClipPathFromRect(Rect rect) {
    //  p0 coordinates.
    //
    //  p0 is the centre of [rect] which lies on top of ButtonArray,
    //  is of twice the width as ButtonArray, and has a centre that is
    //  located at the left or right screen edge.
    Offset p0 = rect.center;

    //  p1 coordinates.
    //
    //  p1 is the point where the curved and straight portions of [clipPath]
    //  are joined. Initialised to zero, this function establishes p1 later on.
    Offset p1 = Offset.zero;

    //  p2 coordinates.
    //
    //  p2 is the Bezier construction point for the curved part of [clipPath].
    //  Initialised to zero, this function establishes p2 later on.
    Offset p2 = Offset.zero;

    //  p3 coordinates,
    //
    //  p3 is the bottom left/right corner of [rect].
    Offset p3 = rect.bottomLeft;

    //  Update p2 with the correct offset.
    double tmp1 = 9 * p3.dy - p0.dy;
    double tmp2 = p3.dy - p0.dy;
    double tmp3 = p3.dx - p0.dx;
    double tmp4 = 9 * tmp2 * tmp2 + 8 * tmp3 * tmp3;
    assert(
        tmp4 >= 0,
        'SettingsPageListTileClipper: developer error, '
        'attempting to take the square root of a negative number.');
    p2 = Offset(p3.dx, (tmp1 - math.sqrt(tmp4)) / 8.0);

    //  Update p1 with the correct offset.
    p1 = Offset((2 * p3.dx - p0.dx) / 3.0, (2 * p3.dy - p0.dy) / 3.0);

    //  Calculate the Offset associated with the new location for the right
    //  edge of SettingsPageListTile.
    //  First establish p.dy.
    Offset p = Offset(0.0, rect.bottom);

    //  Calculate the Offset p for the amalgamated curves, B1 and b2,
    //  that define ClipPath.
    if (p.dy <= p0.dy && p.dy > p1.dy) {
      //  Similar triangles gives the new p.dx value along B1.
      p = Offset(
          p0.dx + (p.dy - p0.dy) * (p1.dx - p0.dx) / (p1.dy - p0.dy), 0.0);
    } else if (p.dy <= p1.dy && p.dy > p3.dy) {
      //  Solve the parametric equation for B2 to give t in terms of p.dy.
      //  Construction variables.
      double a = p1.dy - p2.dy;
      double b = p3.dy - p2.dy;
      double tmp5 = 2 * a * b + (a + b) * (p.dy - p2.dy);
      assert(
          tmp5 >= 0,
          'SettingsPageListTileClipper: developer error, '
          'attempting to take the square root of a negative number.');

      //  Calculate value of t, the value of the parametric variable along B2.
      double t = (2 * a + b + math.sqrt(tmp5)) / (a + b);

      //  Calculate p.dx from t.
      p = Offset(
          p2.dx +
              (2 - t) * (2 - t) * (p1.dx - p2.dx) +
              (t - 1) * (t - 1) * (p3.dx - p2.dx),
          0.0);
    }
    print('p = $p');
    print('rect = $rect');
    print('p0 = $p0');
    print('p1 = $p1');
    print('p2 = $p2');
    print('p3 = $p3');

    //  p1 coordinates.
    return Path();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
