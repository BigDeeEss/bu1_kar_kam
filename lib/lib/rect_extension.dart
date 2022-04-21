//  Import dart packages.
import 'dart:ui';
import 'dart:math' as math;

extension RectExtension on Rect {
  /// Return a new instance of Rect with left and right edges moved
  /// symmetrically so that the new width equates to [newWidth].
  Rect inflateToWidth(double newWidth) {
    return Rect.fromCenter(
      center: center,
      width: newWidth,
      height: height
    );
  }

  /// Return a new instance of Rect with top and bottom edges moved
  /// symmetrically so that the new height equates to [newHeight].
  Rect inflateToHeight(double newHeight) {
    return Rect.fromCenter(
      center: center,
      width: width,
      height: newHeight
    );
  }

  // /// Return a new instance of Rect with top and bottom edges moved outward
  // /// by the given delta.
  // Rect inflateHeight(double delta) {
  //   return Rect.fromLTRB(left, top - delta, right, bottom + delta);
  // }
  //
  // /// Return a new instance of Rect with left and right edges moved outward
  // /// by the given delta.
  // Rect inflateWidth(double delta) {
  //   return Rect.fromLTRB(left - delta, top, right + delta, bottom);
  // }
  //
  // /// Return a new instance of Rect with left edges moved outward
  // /// by the given delta.
  // Rect inflateLeft(double delta) {
  //   return Rect.fromLTRB(left - delta, top, right, bottom);
  // }
  //
  // /// Return a new instance of Rect with right edge moved outward
  // /// by the given delta.
  // Rect inflateRight(double delta) {
  //   return Rect.fromLTRB(left, top, right + delta, bottom);
  // }
  //
  // /// Return a new instance of Rect with top edge moved outward
  // /// by the given delta.
  // Rect inflateUpwards(double delta) {
  //   return Rect.fromLTRB(left, top - delta, right, bottom);
  // }
  //
  // /// Return a new instance of Rect with bottom edge moved outward
  // /// by the given delta.
  // Rect inflateDownwards(double delta) {
  //   return Rect.fromLTRB(left, top, right, bottom + delta);
  // }
  //
  // /// Return a new instance of Rect that shrinks to the left so that it
  // /// excludes [other] if it overlaps.
  // Rect? excludeFromRight(Rect other) {
  //   Rect rect = Rect.fromLTRB(left, top, right, bottom);
  //   if (!rect.overlaps(other)) return rect;
  //   if (right > other.left && left < other.left) {
  //     return Rect.fromLTRB(left, top, math.min(right, other.left), bottom);
  //   } else return null;
  // }
  //
  // /// Return a new instance of Rect that shrinks to the right so that it
  // /// excludes [other] if it overlaps.
  // Rect? excludeFromLeft(Rect other) {
  //   Rect rect = Rect.fromLTRB(left, top, right, bottom);
  //   if (!rect.overlaps(other)) return rect;
  //   if (left < other.right && right > other.right) {
  //     return Rect.fromLTRB(math.max(left, other.right), top, right, bottom);
  //   } else return null;
  // }
}