//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/lib/rect_extension.dart';

class SettingsPageListTileFourBorder extends OutlinedBorder {
  const SettingsPageListTileFourBorder({
    BorderSide side = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
    required this.context,
    this.guestRect,
  })  : assert(side != null),
        assert(borderRadius != null),
        super(side: side);

  final BorderRadiusGeometry borderRadius;
  final BuildContext? context;
  final Rect? guestRect;

  /// Getter for [centralLocalConstructionRect].
  Rect? get centralLocalConstructionRect {
    Rect? rect = localGuestRect;
    if (rect != null) {
      //  Inflate [localGuestRect] to a new height centered on original Rect.
      return rect
          .inflateToHeight(math.max(0.0, rect.height - rect.shortestSide));
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
    Rect? rect = localGuestRect;
    if (rect != null) {
      //  Inflate [localGuestRect] to a new height centered on original Rect.
      rect = rect.inflateToHeight(1.5 * rect.shortestSide);

      //  Calculate shift factor and apply to rect.
      double dy = rect.height + rect.shortestSide / 4.0;
      return rect.shift(Offset(0.0, -dy));
    }
  }

  /// Returns a copy of this ClippedRoundedRectangleBorder with the given
  /// fields replaced with the new values.
  @override
  SettingsPageListTileFourBorder copyWith(
      {BorderSide? side, BorderRadiusGeometry? borderRadius, Rect? guestRect}) {
    return SettingsPageListTileFourBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      context: context,
      guestRect: guestRect ?? this.guestRect,
    );
  }

  double getDeltaX(double y) {
    return 50;
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
    if (upperLocalConstructionRect!.contains(hostRect.bottomLeft) ||
        upperLocalConstructionRect!.contains(hostRect.bottomRight)) {
      //  Bottom of hostRect lies within upperLocalConstructionRect.
      deltaX = getDeltaX(hostRect.bottom);
    } else if (lowerLocalConstructionRect!.contains(hostRect.topLeft) ||
        lowerLocalConstructionRect!.contains(hostRect.topRight)) {
      //  Top of hostRect lies within lowerLocalConstructionRect
      deltaX = getDeltaX(hostRect.top);
    } else if (centralLocalConstructionRect!.contains(hostRect.bottomLeft) ||
        centralLocalConstructionRect!.contains(hostRect.bottomRight) ||
        centralLocalConstructionRect!.contains(hostRect.topLeft) ||
        centralLocalConstructionRect!.contains(hostRect.topRight)) {
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

  /// [scale] returns a new version of SettingsPageListTileFourBorder scaled by t.
  @override
  ShapeBorder scale(double t) {
    return SettingsPageListTileFourBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
      context: context,
      guestRect: guestRect,
    );
  }
}
