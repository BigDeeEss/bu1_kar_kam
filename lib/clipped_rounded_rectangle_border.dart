// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show lerpDouble;
import 'dart:math' as math;

/// A rectangular border with rounded corners.
///
/// Typically used with [ShapeDecoration] to draw a box with a rounded
/// rectangle.
///
/// This shape can interpolate to and from [CircleBorder].
///
/// See also:
///
///  * [BorderSide], which is used to describe each side of the box.
///  * [Border], which, when used with [BoxDecoration], can also
///    describe a rounded rectangle.
class ClippedRoundedRectangleBorder extends OutlinedBorder {
  /// Creates a rounded rectangle border.
  ///
  /// The arguments must not be null.
  const ClippedRoundedRectangleBorder({
    BorderSide side = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
    this.guestRect,
  }) : assert(side != null),
        assert(borderRadius != null),
        super(side: side);

  /// The radii for each corner.
  final BorderRadiusGeometry borderRadius;

  final Rect? guestRect;

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(side.width);
  }

  @override
  ShapeBorder scale(double t) {
    return ClippedRoundedRectangleBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
      guestRect: guestRect,
    );
  }

  // @override
  // ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
  //   assert(t != null);
  //   if (a is ClippedRoundedRectangleBorder) {
  //     return ClippedRoundedRectangleBorder(
  //       side: BorderSide.lerp(a.side, side, t),
  //       borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
  //     );
  //   }
  //   // if (a is CircleBorder) {
  //   //   return _RoundedRectangleToCircleBorder(
  //   //     side: BorderSide.lerp(a.side, side, t),
  //   //     borderRadius: borderRadius,
  //   //     circleness: 1.0 - t,
  //   //   );
  //   // }
  //   return super.lerpFrom(a, t);
  // }

  // @override
  // ShapeBorder? lerpTo(ShapeBorder? b, double t) {
  //   assert(t != null);
  //   if (b is ClippedRoundedRectangleBorder) {
  //     return ClippedRoundedRectangleBorder(
  //       side: BorderSide.lerp(side, b.side, t),
  //       borderRadius: BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
  //     );
  //   }
  //   // if (b is CircleBorder) {
  //   //   return _RoundedRectangleToCircleBorder(
  //   //     side: BorderSide.lerp(side, b.side, t),
  //   //     borderRadius: borderRadius,
  //   //     circleness: t,
  //   //   );
  //   // }
  //   return super.lerpTo(b, t);
  // }

  /// Returns a copy of this ClippedRoundedRectangleBorder with the given fields
  /// replaced with the new values.
  @override
  ClippedRoundedRectangleBorder copyWith({ BorderSide? side, BorderRadiusGeometry? borderRadius }) {
    return ClippedRoundedRectangleBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      guestRect: guestRect,
    );
  }

  double _clampToShortest(RRect rrect, double value) {
    return value > rrect.shortestSide ? rrect.shortestSide : value;
  }

  Path _getPath(RRect rrect) {
    final double left = rrect.left;
    final double right = rrect.right;
    final double top = rrect.top;
    final double bottom = rrect.bottom;
    //  Radii will be clamped to the value of the shortest side
    // of rrect to avoid strange tie-fighter shapes.
    final double tlRadiusX =
    math.max(0.0, _clampToShortest(rrect, rrect.tlRadiusX));
    final double tlRadiusY =
    math.max(0.0, _clampToShortest(rrect, rrect.tlRadiusY));
    final double trRadiusX =
    math.max(0.0, _clampToShortest(rrect, rrect.trRadiusX));
    final double trRadiusY =
    math.max(0.0, _clampToShortest(rrect, rrect.trRadiusY));
    final double blRadiusX =
    math.max(0.0, _clampToShortest(rrect, rrect.blRadiusX));
    final double blRadiusY =
    math.max(0.0, _clampToShortest(rrect, rrect.blRadiusY));
    final double brRadiusX =
    math.max(0.0, _clampToShortest(rrect, rrect.brRadiusX));
    final double brRadiusY =
    math.max(0.0, _clampToShortest(rrect, rrect.brRadiusY));

    Path hostPath = Path();
    hostPath
      ..addRRect(rrect.deflate(20));
    return hostPath;

    return Path()
      ..moveTo(left, top + tlRadiusX)
      ..cubicTo(left, top, left, top, left + tlRadiusY, top)
      ..lineTo(right - trRadiusX, top)
      ..cubicTo(right, top, right, top, right, top + trRadiusY)
      ..lineTo(right, bottom - brRadiusX)
      ..cubicTo(right, bottom, right, bottom, right - brRadiusY, bottom)
      ..lineTo(left + blRadiusX, bottom)
      ..cubicTo(left, bottom, left, bottom, left, bottom - blRadiusY)
      ..close();
  }


  @override
  Path getInnerPath(Rect rect, { TextDirection? textDirection }) {
    return _getPath(borderRadius.resolve(textDirection).toRRect(rect).deflate(side.width));
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
    return _getPath(borderRadius.resolve(textDirection).toRRect(rect));
  }

  // @override
  // Path getInnerPath(Rect rect, { TextDirection? textDirection }) {
  //   Path hostPath = Path()
  //     ..addRRect(borderRadius.resolve(textDirection).toRRect(rect).deflate(side.width));
  //   Path guestPath = Path();
  //   // print('getInnerPath, borderRadius = $borderRadius');
  //   // print('getInnerPath, rect = $rect');
  //   // print('getInnerPath, guestRect = $guestRect');
  //   if (guestRect != null) {
  //     guestPath..addRRect(borderRadius.resolve(textDirection).toRRect(guestRect!).inflate(side.width));
  //   }
  //   // print('paint, hostPath = ${hostPath.toString()}');
  //   // print('paint, guestPath = ${guestPath.toString()}');
  //   return Path.combine(PathOperation.difference, hostPath, guestPath);
  //   // return Path()
  //   //   ..addRRect(borderRadius.resolve(textDirection).toRRect(rect).deflate(side.width));
  // }


  // @override
  // Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
  //   Path hostPath = Path()
  //     ..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  //   Path guestPath = Path();
  //   // print('getOuterPath, borderRadius = $borderRadius');
  //   // print('getOuterPath, rect = $rect');
  //   // print('getOuterPath, guestRect = $guestRect');
  //   if (guestRect != null) {
  //     guestPath..addRRect(borderRadius.resolve(textDirection).toRRect(guestRect!));
  //   }
  //   // print('paint, hostPath = ${hostPath.toString()}');
  //   // print('paint, guestPath = ${guestPath.toString()}');
  //   return Path.combine(PathOperation.difference, hostPath, guestPath);
  //   // return Path()
  //   //   ..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  // }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection? textDirection }) {
    print('paint, rect = $rect');
    if (rect.isEmpty)
      return;
    print('paint, 1');
    switch (side.style) {
      case BorderStyle.none:
        print('paint, 2');
        break;
      case BorderStyle.solid:
        print('paint, 3');
        final Path path = getOuterPath(rect, textDirection: textDirection);
        final Paint paint = side.toPaint();

        print('path.toString()');
        print(path.toString());
        print('path.toString()');

        canvas.drawPath(path, paint);
        break;
    }
  }

  // @override
  // void paint(Canvas canvas, Rect rect, { TextDirection? textDirection }) {
  //   print(borderRadius);
  //   switch (side.style) {
  //     case BorderStyle.none:
  //       break;
  //     case BorderStyle.solid:
  //       final double width = side.width;
  //       if (width == 0.0) {
  //         canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), side.toPaint());
  //       } else {
  //         final RRect outer = borderRadius.resolve(textDirection).toRRect(rect);
  //         final RRect inner = outer.deflate(width);
  //         final Paint paint = Paint()
  //           ..color = side.color;
  //         canvas.drawDRRect(outer, inner, paint);
  //       }
  //   }
  // }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType)
      return false;
    return other is ClippedRoundedRectangleBorder
        && other.side == side
        && other.borderRadius == borderRadius
        && other.guestRect == guestRect;
  }

  @override
  int get hashCode => hashValues(side, borderRadius, guestRect);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'ClippedRoundedRectangleBorder')}($side, $borderRadius, $guestRect)';
  }
}

// class _RoundedRectangleToCircleBorder extends OutlinedBorder {
//   const _RoundedRectangleToCircleBorder({
//     BorderSide side = BorderSide.none,
//     this.borderRadius = BorderRadius.zero,
//     required this.circleness,
//   }) : assert(side != null),
//         assert(borderRadius != null),
//         assert(circleness != null),
//         super(side: side);
//
//   final BorderRadiusGeometry borderRadius;
//
//   final double circleness;
//
//   @override
//   EdgeInsetsGeometry get dimensions {
//     return EdgeInsets.all(side.width);
//   }
//
//   @override
//   ShapeBorder scale(double t) {
//     return _RoundedRectangleToCircleBorder(
//       side: side.scale(t),
//       borderRadius: borderRadius * t,
//       circleness: t,
//     );
//   }
//
//   @override
//   ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
//     assert(t != null);
//     if (a is ClippedRoundedRectangleBorder) {
//       return _RoundedRectangleToCircleBorder(
//         side: BorderSide.lerp(a.side, side, t),
//         borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
//         circleness: circleness * t,
//       );
//     }
//     if (a is CircleBorder) {
//       return _RoundedRectangleToCircleBorder(
//         side: BorderSide.lerp(a.side, side, t),
//         borderRadius: borderRadius,
//         circleness: circleness + (1.0 - circleness) * (1.0 - t),
//       );
//     }
//     if (a is _RoundedRectangleToCircleBorder) {
//       return _RoundedRectangleToCircleBorder(
//         side: BorderSide.lerp(a.side, side, t),
//         borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
//         circleness: ui.lerpDouble(a.circleness, circleness, t)!,
//       );
//     }
//     return super.lerpFrom(a, t);
//   }
//
//   @override
//   ShapeBorder? lerpTo(ShapeBorder? b, double t) {
//     if (b is ClippedRoundedRectangleBorder) {
//       return _RoundedRectangleToCircleBorder(
//         side: BorderSide.lerp(side, b.side, t),
//         borderRadius: BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
//         circleness: circleness * (1.0 - t),
//       );
//     }
//     if (b is CircleBorder) {
//       return _RoundedRectangleToCircleBorder(
//         side: BorderSide.lerp(side, b.side, t),
//         borderRadius: borderRadius,
//         circleness: circleness + (1.0 - circleness) * t,
//       );
//     }
//     if (b is _RoundedRectangleToCircleBorder) {
//       return _RoundedRectangleToCircleBorder(
//         side: BorderSide.lerp(side, b.side, t),
//         borderRadius: BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
//         circleness: ui.lerpDouble(circleness, b.circleness, t)!,
//       );
//     }
//     return super.lerpTo(b, t);
//   }
//
//   Rect _adjustRect(Rect rect) {
//     if (circleness == 0.0 || rect.width == rect.height)
//       return rect;
//     if (rect.width < rect.height) {
//       final double delta = circleness * (rect.height - rect.width) / 2.0;
//       return Rect.fromLTRB(
//         rect.left,
//         rect.top + delta,
//         rect.right,
//         rect.bottom - delta,
//       );
//     } else {
//       final double delta = circleness * (rect.width - rect.height) / 2.0;
//       return Rect.fromLTRB(
//         rect.left + delta,
//         rect.top,
//         rect.right - delta,
//         rect.bottom,
//       );
//     }
//   }
//
//   BorderRadius? _adjustBorderRadius(Rect rect, TextDirection? textDirection) {
//     final BorderRadius resolvedRadius = borderRadius.resolve(textDirection);
//     if (circleness == 0.0)
//       return resolvedRadius;
//     return BorderRadius.lerp(resolvedRadius, BorderRadius.circular(rect.shortestSide / 2.0), circleness);
//   }
//
//   @override
//   Path getInnerPath(Rect rect, { TextDirection? textDirection }) {
//     return Path()
//       ..addRRect(_adjustBorderRadius(rect, textDirection)!.toRRect(_adjustRect(rect)).deflate(side.width));
//   }
//
//   @override
//   Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
//     return Path()
//       ..addRRect(_adjustBorderRadius(rect, textDirection)!.toRRect(_adjustRect(rect)));
//   }
//
//   @override
//   _RoundedRectangleToCircleBorder copyWith({ BorderSide? side, BorderRadiusGeometry? borderRadius, double? circleness }) {
//     return _RoundedRectangleToCircleBorder(
//       side: side ?? this.side,
//       borderRadius: borderRadius ?? this.borderRadius,
//       circleness: circleness ?? this.circleness,
//     );
//   }
//
//   @override
//   void paint(Canvas canvas, Rect rect, { TextDirection? textDirection }) {
//     switch (side.style) {
//       case BorderStyle.none:
//         break;
//       case BorderStyle.solid:
//         final double width = side.width;
//         if (width == 0.0) {
//           canvas.drawRRect(_adjustBorderRadius(rect, textDirection)!.toRRect(_adjustRect(rect)), side.toPaint());
//         } else {
//           final RRect outer = _adjustBorderRadius(rect, textDirection)!.toRRect(_adjustRect(rect));
//           final RRect inner = outer.deflate(width);
//           final Paint paint = Paint()
//             ..color = side.color;
//           canvas.drawDRRect(outer, inner, paint);
//         }
//     }
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (other.runtimeType != runtimeType)
//       return false;
//     return other is _RoundedRectangleToCircleBorder
//         && other.side == side
//         && other.borderRadius == borderRadius
//         && other.circleness == circleness;
//   }
//
//   @override
//   int get hashCode => hashValues(side, borderRadius, circleness);
//
//   @override
//   String toString() {
//     return 'ClippedRoundedRectangleBorder($side, $borderRadius, ${(circleness * 100).toStringAsFixed(1)}% of the way to being a CircleBorder)';
//   }
// }