//  Import flutter packages.
import 'package:flutter/material.dart';

class SettingsPageListTileBorder extends ContinuousRectangleBorder {
  const SettingsPageListTileBorder({
    BorderSide side = BorderSide.none,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    required this.context,
    this.guestRect,
  })  : assert(side != null),
        assert(borderRadius != null),
        super(side: side, borderRadius: borderRadius);

  final BuildContext? context;

  final Rect? guestRect;

  Rect get hostRect {
    RenderBox renderBox = context?.findRenderObject() as RenderBox;
    print(renderBox);
    return Offset.zero & Size.square(1);
  }

  /// [scale] returns a new version of SettingsPageListTileBorder scaled by t.
  @override
  ShapeBorder scale(double t) {
    return SettingsPageListTileBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
      context: context,
      guestRect: guestRect,
    );
  }

  /// Returns a copy of this ClippedRoundedRectangleBorder with the given fields
  /// replaced with the new values.
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

  
}
