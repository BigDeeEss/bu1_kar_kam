//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/lib/rect_extension.dart';

class SettingsPageListTileBorder extends OutlinedBorder {
  const SettingsPageListTileBorder({
    BorderSide side = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
    required this.context,
    this.guestRect,
  })  : assert(side != null),
        assert(borderRadius != null),
        super(side: side);

  /// [borderRadius] defines the corner radius for
  /// [SettingsPageListTileWithCard] or [SettingsPageListTileWithMaterial].
  final BorderRadiusGeometry borderRadius;

  /// [context] is required for obtaining [localGuestRect] from RenderBox.
  final BuildContext? context;

  /// [guestRect] is the Rect arund which [SettingsPageListTileBorder]
  /// guides ListTile on scroll.
  final Rect? guestRect;

  /// Getter for [centralLocalConstructionRect].
  Rect? get centralLocalConstructionRect {
    Rect? rect = localGuestRect;
    if (rect != null) {
      //  Inflate [localGuestRect] to a new height centered on original Rect.
      return rect
          .inflateToHeight(math.max(0.0, rect.height - rect.shortestSide + 10));
    }
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  /// Getter for [localGuestRect].
  Rect? get localGuestRect {
    //  Get [renderBox] associated with [SettingsPageListTileFour].
    //  (Used to generate [guestRect] and [localGuestRect].)
    //
    //  Either use ! to ensure context is not null, or ?. to ensure that
    //  findRenderObject() is only called if context is not null.
    RenderBox renderBox = context!.findRenderObject() as RenderBox;

    //  Get the global offset associated with the top left corner of
    //  [SettingsPageListTileFour] relative to the top left screen corner.
    Offset offset = renderBox.globalToLocal(Offset.zero);

    //  Transform [guestRect] from the global coordinate system relative to the
    //  top left screen corner to a system local to [renderBox], which
    //  represents the current local instance of ListTile.
    return guestRect?.shift(offset);
  }

  /// Getter for [lowerLocalConstructionRect].
  Rect? get lowerLocalConstructionRect {
    Rect? rect = localGuestRect;
    if (rect != null) {
      //  Inflate [localGuestRect] to a new height centered on original Rect.
      rect = rect.inflateToHeight(1.5 * rect.shortestSide);

      //  Calculate shift factor and apply to rect.
      double dy = rect.height + rect.shortestSide / 4.0;
      return rect.shift(Offset(0.0, dy));
    }
  }

  /// Getter for [upperLocalConstructionRect]
  Rect? get upperLocalConstructionRect {
    Rect? lgr = localGuestRect;
    if (lgr != null) {
      //  Inflate [lgr] to a new height centered on original Rect.
      Rect rect = lgr.inflateToHeight(1.5 * lgr.shortestSide);

      //  Calculate shift factor and apply to rect.
      double dy = rect.height / 2.0 + lgr.height / 2.0 - lgr.shortestSide / 2.0;
      return rect.shift(Offset(0.0, -dy));
    }
  }

  /// Returns a copy of this ClippedRoundedRectangleBorder with the given
  /// fields replaced with the new values.
  @override
  SettingsPageListTileBorder copyWith(
      {BorderSide? side, BorderRadiusGeometry? borderRadius, Rect? guestRect}) {
    return SettingsPageListTileBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      context: context,
      guestRect: guestRect ?? this.guestRect,
    );
  }

  /// [getDeltaXFromUpperLocalConstructionRect] calculates the amount,
  /// [deltaX], to increase the width of [SettingsPageListTile] from its
  /// minimum value in order to fill the screen. The minimum value
  /// corresponds to when [SettingsPageListTile] is alongside [ButtonArray].
  ///
  /// [deltaX] = 0 corresponds to the position where [SettingsPageListTile]
  /// is alongside or passing [ButtonArray]. From the side of the screen,
  /// this means maximum deflection.
  ///
  /// For the purpose of calculating deltaX, the origin is taken to be
  /// the bottom left corner of [upperLocalConstructionRect].
  ///
  /// The value of [deltaX] is the horizontal adjustment to applied to the
  /// width of [SettingsPageListTile]. In other words the bottom corner
  /// follows a path that is made up of a curved, circular section and a line
  /// segment. The line passes through (a,b) and is tangent to the curve
  /// at (xCrit, yCrit).
  double getDeltaXFromUpperLocalConstructionRect(double y) {
    //  Screen coordinate system has positive y pointing downwards.
    //  Change y coordinate so that it points upwards with y = 0
    //  corresponding to the bottom of [upperLocalConstructionRect].
    y = upperLocalConstructionRect!.bottom - y;

    //  [r] is the radius of the bottom curved path section. The centre of
    //  the corresponding circle is (r,0).
    double r = upperLocalConstructionRect!.shortestSide / 2.0;

    //  [a] and [b] are the coordinates of the point of symmetry, taken to
    //  be the centre of [upperLocalConstructionRect].
    double a = upperLocalConstructionRect!.width / 2.0;
    double b = upperLocalConstructionRect!.height / 2.0;

    //  In order to avoid generating complex numbers aa + bb - 2ra = c - 2ra
    //  must be greater than zero.
    assert(a * a + b * b - 2 * r * a >= 0,
        'Error: complex number generated by square root.');

    //  The negative square root is taken as otherwise, with (a,b) = (2r,r),
    //  the positive root implies a vertical line segment with yCrit < 0.
    double xCrit =
        (a * a + b * b - r * a - b * math.sqrt(a * a + b * b - 2 * r * a)) *
            r /
            (b * b + (a - r) * (a - r));

    //  To get yCrit invert the equation of a circle,
    //      (x - r)^2 + (y - 0)^2 = r^2.
    double yCrit = math.sqrt(r * r - (xCrit - r) * (xCrit - r));

    //  Technically, in what follows deltaX is calculated so that deltaX = 0
    //  corresponds to the maximum
    double deltaX = 0.0;
    if (y < 0) {
      //  The default value corresponding to the maximum deltaX.
      //  This catches any gap between [centralLocalConstructionRect]
      //  and [upperLocalConstructionRect]. If this isn't deployed then
      //  [SettingsPageListTile] shows jerky motion.
      deltaX = 0.0;
      print('T0');
    } else if (y < yCrit) {
      //  The bottom left corner of [upperLocalConstructionRect] is the origin
      //  of the bounding box.
      //  (xCrit,yCrit) is the point where the curve joins to the line segment.
      //  (r,0) is the centre of the circle. To get deltaX invert
      //      (x - r)^2 + (y - 0)^2 = r^2,
      //  taking the negative root.
      deltaX = r - math.sqrt(r * r - y * y);
      print('T1');
    } else if (y < 2 * b - yCrit) {
      //  The bottom left corner of upperLocalConstructionRect is the origin
      //  of the bounding box.
      //  By symmetry, the line segment joins (xCrit,yCrit) to
      //  (2a - xCrit,2b - yCrit).
      //  To get the equation for deltaX invert
      //      (x - xCrit) / (y - yCrit)
      //          = (2a - xCrit - xCrit) / (2b - yCrit - yCrit),
      //  which just equates gradients.
      deltaX = xCrit + (y - yCrit) * (a - xCrit) / (b - yCrit);
      print('T2');
    } else if (y < 2 * b) {
      //  The bottom left corner of upperLocalConstructionRect is the origin.
      //  (2a - xCrit,2b - yCrit is the point where the curve joins to the
      //  line segment.
      //  (2a - r,2b) is the centre of the circle. To get deltaX invert
      //      (x - (2a - r))^2 + (y - 2b)^2 = r^2
      //  taking the positive root.
      deltaX = (2 * a - r) + math.sqrt(r * r - (y - 2 * b) * (y - 2 * b));
      print('T3');
    } else {
      print('Error');
    }
    print(
        'y = $y, r = $r, a = $a, b = $b, xCrit = $xCrit, yCrit = $yCrit, deltaX = $deltaX, (2 * b - yCrit) = ${2 * b - yCrit}');
    return 2 * a - deltaX;
  }

  /// [getDeltaXFromLowerLocalConstructionRect] calculates the amount,
  /// [deltaX], to increase the width of [SettingsPageListTile] from its
  /// minimum value in order to fill the screen. The minimum value
  /// corresponds to when [SettingsPageListTile] is alongside [ButtonArray].
  ///
  /// [deltaX] = 0 corresponds to the position where [SettingsPageListTile]
  /// is alongside or passing [ButtonArray]. Relative to the screen edge,
  /// this means maximum deflection. [deltaX] is a smooth function of [y],
  /// which is the vertical displacement between the bottom edge of
  /// [lowerLocalConstructionRect] and the top edge of [SettingsPageListTile].
  ///
  /// For the purpose of calculating deltaX, the origin is taken to be
  /// the bottom left corner of [lowerLocalConstructionRect].
  ///
  /// The value of [deltaX] is the horizontal adjustment to applied to the
  /// width of [SettingsPageListTile]. In other words the bottom corner
  /// follows a path that is made up of a curved, circular section and a line
  /// segment. The line passes through (a,b) and is tangent to the curve
  /// at (xCrit, yCrit).
  double getDeltaXFromLowerLocalConstructionRect(double y) {
    return 150;
  }

  /// [getHostRect] converts RRect associated with the current instance
  /// of [SettingsPageListTileFour] to Rect.
  Rect getHostRect(RRect rrect) => rrect.outerRect;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(
        borderRadius.resolve(textDirection).toRRect(rect).deflate(side.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(borderRadius.resolve(textDirection).toRRect(rect));
  }

  Path _getPath(RRect rrect) {
    //  Set default value for hostPath.
    Path hostPath = Path()..addRRect(rrect);

    //  Return [hostPath] and exit if [localGuestRect] is null.
    if (localGuestRect == null) return hostPath;

    //  Set initial value of deltaX to zero. Use getDeltaX immediately below
    //  to modify this value if the conditions are correct.
    double deltaX = 0.0;
    Rect hostRect = rrect.outerRect;
    if (upperLocalConstructionRect!.boundsContain(hostRect.bottomLeft) ||
        upperLocalConstructionRect!.boundsContain(hostRect.bottomRight)) {
      //  Bottom of hostRect lies within upperLocalConstructionRect.
      deltaX = getDeltaXFromUpperLocalConstructionRect(
          hostRect.bottom + AppSettings.buttonRadiusInner / 2.0);
    } else if (lowerLocalConstructionRect!.boundsContain(hostRect.topLeft) ||
        lowerLocalConstructionRect!.boundsContain(hostRect.topRight)) {
      //  Top of hostRect lies within lowerLocalConstructionRect
      // deltaX = getDeltaXFromLowerLocalConstructionRect(hostRect.top);
    } else if (centralLocalConstructionRect!
            .boundsContain(hostRect.bottomLeft) ||
        centralLocalConstructionRect!.boundsContain(hostRect.bottomRight) ||
        centralLocalConstructionRect!.boundsContain(hostRect.topLeft) ||
        centralLocalConstructionRect!.boundsContain(hostRect.topRight)) {
      //  Bottom OR top of hostRect lies within upperLocalConstructionRect
      deltaX = localGuestRect!.width;
    }

    // Calculate [relativeOffset] to determine whether to clip
    // SettingsPageListTileFour on the left or right.
    Offset relativeOffset = localGuestRect!.center - hostRect.center;

    //  Generate a Path variable representing the boundary of hostRect.
    hostPath = Path();
    if (relativeOffset.dx >= 0) {
      hostPath.addRRect(RRect.fromLTRBR(hostRect.left, hostRect.top,
          hostRect.right - deltaX, hostRect.bottom, Radius.circular(25.0)));
    } else if (relativeOffset.dx < 0) {
      hostPath.addRRect(RRect.fromLTRBR(hostRect.left + deltaX, hostRect.top,
          hostRect.right, hostRect.bottom, Radius.circular(25.0)));
    }
    return hostPath;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) return;
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final Path path = getOuterPath(rect, textDirection: textDirection);
        final Paint paint = side.toPaint();
        canvas.drawPath(path, paint);
        break;
    }
  }

  /// [scale] returns a new version of SettingsPageListTileSixBorder scaled by t.
  @override
  ShapeBorder scale(double t) {
    return SettingsPageListTileBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
      context: context,
      guestRect: guestRect,
    );
  }
}
