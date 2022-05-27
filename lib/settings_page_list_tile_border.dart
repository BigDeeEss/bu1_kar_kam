//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/lib/rect_extension.dart';

/// [SettingsPageListTileBorder] generates a version of RoundedRectangleBorder
/// that can dynamically adjust its width in order to pass around [guestRect]
/// in a ListView.
class SettingsPageListTileBorder extends OutlinedBorder {
  const SettingsPageListTileBorder({
    required this.context,
    this.guestRect,
    required this.pathNotifier,
    this.radius = Radius.zero,
    BorderSide side = BorderSide.none,
  })  : assert(side != null),
        assert(radius != null),
        assert(context != null),
        super(side: side);

  /// [context] is required for obtaining [localGuestRect] from RenderBox.
  final BuildContext context;

  /// [guestRect] is the Rect around which [SettingsPageListTileBorder]
  /// guides [SettingsPageListTile] on scroll.
  final Rect? guestRect;

  /// [pathNotifier] is required for feeding back the inner path calculated
  /// during the shape transformation as [SettingsPageListTileBorder]
  /// passes by [guestRect].
  final ValueNotifier<Path> pathNotifier;

  /// [radius] defines the corner radius for [SettingsPageListTileWithCard] or
  /// [SettingsPageListTileWithMaterial].
  final Radius radius;

  /// Getter for [centralLocalConstructionRect].
  Rect? get centralLocalConstructionRect {
    Rect? rect = localGuestRect;
    if (rect != null) {
      //  Inflate [rect] to a new height centered on the original [rect].
      return rect
          .inflateToHeight(math.max(0.0, rect.height - rect.shortestSide));
    }
    return null;
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  /// Getter for [localGuestRect].
  Rect? get localGuestRect {
    //  Get [renderBox] associated with [SettingsPageListTile].
    //  ([renderBox] is used to generate [localGuestRect] from [guestRect].)
    RenderBox renderBox = context.findRenderObject() as RenderBox;

    //  Get the global offset associated with the top left corner of
    //  [SettingsPageListTile] relative to the top left screen corner.
    Offset offset = renderBox.globalToLocal(Offset.zero);

    //  Transform [guestRect] from the global coordinate system to one that is
    //  local to [renderBox] or the current local instance of ListTile.
    return guestRect?.shift(offset);
  }

  /// Getter for [lowerLocalConstructionRect].
  Rect? get lowerLocalConstructionRect {
    Rect? lgr = localGuestRect;
    if (lgr != null) {
      //  Inflate [localGuestRect] to a new height centered on original Rect.
      Rect rect = lgr.inflateToHeight(1.0 * lgr.shortestSide);

      //  Calculate shift factor and apply to rect.
      double dy =
          lgr.height / 2.0 + rect.height / 2.0 - rect.shortestSide / 2.0;
      return rect.shift(Offset(0.0, dy));
    }
    return null;
  }

  /// Getter for [upperLocalConstructionRect]
  Rect? get upperLocalConstructionRect {
    Rect? lgr = localGuestRect;
    if (lgr != null) {
      //  Inflate [rect] to a new height centered on original Rect.
      Rect rect = lgr.inflateToHeight(1.0 * lgr.shortestSide);

      //  Calculate shift factor and apply to rect.
      double dy =
          lgr.height / 2.0 + rect.height / 2.0 - rect.shortestSide / 2.0;
      return rect.shift(Offset(0.0, -dy));
    }
    return null;
  }

  /// Returns a copy of this [SettingsPageListTileBorder] with the given
  /// fields replaced with the new values.
  @override
  SettingsPageListTileBorder copyWith(
      {BorderSide? side, Radius? radius, Rect? guestRect}) {
    return SettingsPageListTileBorder(
      context: context,
      guestRect: guestRect ?? this.guestRect,
      pathNotifier: pathNotifier,
      radius: radius ?? this.radius,
      side: side ?? this.side,
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
    //  The method for determining [deltaX] is follows the method for
    //  obtaining [getDeltaXFromLowerLocalConstructionRect].
    //  [a] is the x-coordinate of the point of symmetry, taken to
    //  be the centre of [upperLocalConstructionRect], relative to
    //  upperLocalConstructionRect!.bottom.
    double a = upperLocalConstructionRect!.width / 2.0;
    return 2 * a - getDeltaXFromLowerLocalConstructionRect(y);
  }

  /// [getDeltaXFromLowerLocalConstructionRect] calculates the amount,
  /// [deltaX], to decrease the width of [SettingsPageListTile] from its
  /// maximum value in order to accommodate [ButtonArray].
  ///
  /// The maximum value of [deltaX] corresponds to when [SettingsPageListTile]
  /// is alongside [ButtonArray] when it has the minimum value, [deltaX] = 0.
  ///
  /// [deltaX] is a smooth function of [y], the vertical displacement between
  /// the bottom edge of [lowerLocalConstructionRect] and the top edge of
  /// [SettingsPageListTile]. For the purpose of calculating deltaX, the origin
  /// is taken to be the bottom left corner of [lowerLocalConstructionRect].
  ///
  /// The bottom corner follows a path that is made up of a curved, circular
  /// section and a line segment. The line passes through (a,b), the coordinates
  /// of the centre point of [lowerLocalConstructionRect], and is tangent to
  /// the curve at (xCrit, yCrit).
  double getDeltaXFromLowerLocalConstructionRect(double y) {
    //  [r] is the radius of the curved path section.
    double r = lowerLocalConstructionRect!.shortestSide / 2.0;

    //  ([a], [b]) are the coordinates of the point of symmetry, taken to
    //  be the centre of [lowerLocalConstructionRect]. Relative to the
    //  bottom left corner of [lowerLocalConstructionRect], [a] and [b] have
    //  the values as follows.
    double a = lowerLocalConstructionRect!.width / 2.0;
    double b = lowerLocalConstructionRect!.height / 2.0;

    //  In order to avoid generating complex numbers aa + bb - 2ra must be
    //  greater than zero.
    assert(a * a + b * b - 2 * r * a >= 0,
        'SettingsPageListTileBorder, getDeltaXFromLowerLocalConstructionRect: '
        'error, complex number generated by square root.');

    //  The negative square root is taken as otherwise, with (a,b) = (2r,r),
    //  the positive root implies a vertical line segment with yCrit < 0.
    double xCrit =
        (a * a + b * b - r * a - b * math.sqrt(a * a + b * b - 2 * r * a)) *
            r / (b * b + (a - r) * (a - r));

    //  To get yCrit invert the equation of a circle,
    //      (x - r)^2 + (y - 0)^2 = r^2.
    double yCrit = math.sqrt(r * r - (xCrit - r) * (xCrit - r));

    //  Calculate deltaX. A zero [deltaX] corresponds to the default value
    //  representing when [SettingsPageListTile] takes its maximum width.
    double deltaX = 0.0;
    if (y < yCrit) {
      //  The bottom left corner of [lowerLocalConstructionRect] is the origin
      //  of the bounding box.
      //
      //  (xCrit,yCrit) is the point where the curve joins to the line segment.
      //  (r,0) is the centre of the circle. To get deltaX invert
      //      (x - r)^2 + (y - 0)^2 = r^2,
      //  taking the negative root.
      deltaX = r - math.sqrt(r * r - y * y);
    } else if (y < 2 * b - yCrit) {
      //  The bottom left corner of [lowerLocalConstructionRect] is the origin
      //  of the bounding box.
      //
      //  By symmetry, the line segment joins (xCrit,yCrit) to
      //  (2a - xCrit,2b - yCrit). To get the equation for deltaX invert
      //      (x - xCrit) / (y - yCrit)
      //          = (2a - xCrit - xCrit) / (2b - yCrit - yCrit),
      //  which just equates gradients.
      deltaX = xCrit + (y - yCrit) * (a - xCrit) / (b - yCrit);
    } else if (y < 2 * b) {
      //  The bottom left corner of [lowerLocalConstructionRect] is the origin
      //  of the bounding box.
      //
      //  (2a - xCrit,2b - yCrit is the point where the curve joins to the
      //  line segment. (2a - r,2b) is the centre of the circle. To get
      //  deltaX invert
      //      (x - (2a - r))^2 + (y - 2b)^2 = r^2
      //  taking the positive root.
      deltaX = (2 * a - r) + math.sqrt(r * r - (y - 2 * b) * (y - 2 * b));
    } else {
      assert(false,
        'SettingsPageListTileBorder, getDeltaXFromLowerLocalConstructionRect: '
        'error, invalid y-value.');
    }
    //
    return deltaX;
  }

  /// [getHostRect] converts RRect associated with the current instance
  /// of [SettingsPageListTile] to Rect.
  Rect getHostRect(RRect rrect) => rrect.outerRect;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(BorderRadius.all(radius)
        .resolve(textDirection)
        .toRRect(rect)
        .deflate(side.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(
        BorderRadius.all(radius).resolve(textDirection).toRRect(rect));
  }

  Path _getPath(RRect rrect) {
    //  Set default value for hostPath.
    Path hostPath = Path()..addRRect(rrect);

    //  Return [hostPath] and exit if [localGuestRect] is null.
    if (localGuestRect == null) return hostPath;

    double deltaX = 0.0;
    Rect hostRect = rrect.outerRect;
    if (upperLocalConstructionRect!.boundsContain(hostRect.bottomLeft) ||
        upperLocalConstructionRect!.boundsContain(hostRect.bottomRight)) {
      //  Bottom of [hostRect] lies within [upperLocalConstructionRect].
      //  Transform hostRect.bottom so that it represents a displacement in the
      //  upwards direction relative to upperLocalConstructionRect!.bottom.
      deltaX = getDeltaXFromUpperLocalConstructionRect(
          upperLocalConstructionRect!.bottom - hostRect.bottom);
    } else if (lowerLocalConstructionRect!.boundsContain(hostRect.topLeft) ||
        lowerLocalConstructionRect!.boundsContain(hostRect.topRight)) {
      //  Top of [hostRect] lies within [lowerLocalConstructionRect]
      //  Transform hostRect.top so that it represents a displacement in the
      //  upwards direction relative to lowerLocalConstructionRect!.bottom.
      deltaX = getDeltaXFromLowerLocalConstructionRect(
          lowerLocalConstructionRect!.bottom - hostRect.top);
    } else if (centralLocalConstructionRect!.overlaps(hostRect)) {
      //  [hostRect] overlaps with [upperLocalConstructionRect].
      deltaX = localGuestRect!.width;
    }

    // Calculate [relativeOffset] to determine whether to clip
    // SettingsPageListTile on the left or right.
    Offset relativeOffset = localGuestRect!.center - hostRect.center;

    //  Generate a Path variable representing the boundary of hostRect.
    hostPath = Path();
    if (relativeOffset.dx >= 0) {
      hostPath.addRRect(RRect.fromLTRBR(hostRect.left, hostRect.top,
          hostRect.right - deltaX, hostRect.bottom, radius));
    } else if (relativeOffset.dx < 0) {
      hostPath.addRRect(RRect.fromLTRBR(hostRect.left + deltaX, hostRect.top,
          hostRect.right, hostRect.bottom, radius));
    }
    //  Upload hostPath to pathNotifier and return.
    pathNotifier.value = hostPath;
    // print('pathNotifier = ${pathNotifier.value.getBounds()}');
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
      context: context,
      guestRect: guestRect,
      radius: radius * t,
      pathNotifier: pathNotifier,
      side: side.scale(t),
    );
  }
}
