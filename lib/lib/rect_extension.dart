//  Import dart packages.
import 'dart:ui';

extension RectExtension on Rect {
  /// Return a new instance of Rect with top and bottom edges moved outward
  /// by the given delta.
  Rect inflateHeight(double delta) {
    return Rect.fromLTRB(left, top - delta, right, bottom + delta);
  }

  /// Return a new instance of Rect with left and right edges moved outward
  /// by the given delta.
  Rect inflateWidth(double delta) {
    return Rect.fromLTRB(left - delta, top, right + delta, bottom);
  }

  /// Return a new instance of Rect with left edges moved outward
  /// by the given delta.
  Rect inflateLeft(double delta) {
    return Rect.fromLTRB(left - delta, top, right, bottom);
  }

  /// Return a new instance of Rect with right edge moved outward
  /// by the given delta.
  Rect inflateRight(double delta) {
    return Rect.fromLTRB(left, top, right + delta, bottom);
  }

  /// Return a new instance of Rect with top edge moved outward
  /// by the given delta.
  Rect inflateUpwards(double delta) {
    return Rect.fromLTRB(left, top - delta, right, bottom);
  }

  /// Return a new instance of Rect with bottom edge moved outward
  /// by the given delta.
  Rect inflateDownwards(double delta) {
    return Rect.fromLTRB(left, top, right, bottom + delta);
  }
}