//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/lib/rect_extension.dart';

class ListViewBuilderSettingsPageListTile extends StatelessWidget {
  ListViewBuilderSettingsPageListTile({
    Key? key,
    required this.basePageViewRect,
    required this.guestRect,
    required this.index,
    required this.maxWidth,
    this.offset,
  }) : super(key: key) {
    rect = Offset(0, height * index) & Size(maxWidth, height);
    if (basePageViewRect != null) {
      rect = rect.shift(Offset(0.0, basePageViewRect!.top));
    }
    centralConstructionRect = centralConstructionRectFromGuestRect;
    lowerConstructionRect = lowerConstructionRectFromGuestRect;
    upperConstructionRect = upperConstructionRectFromGuestRect;
    if (index == 0) {
      print('index = $index');
      print('basePageViewRect = $basePageViewRect');
      print('guestRect = $guestRect');
      print('lowerConstructionRect = $lowerConstructionRect');
      print('upperConstructionRect = $upperConstructionRect');
      print('$index, rect = $rect');
    }
  }

  final Rect? basePageViewRect;
  final Rect guestRect;
  final int index;
  final double maxWidth;
  final Offset? offset;

  double height = 75.0;
  Rect centralConstructionRect = Rect.zero;
  Rect lowerConstructionRect = Rect.zero;
  Rect rect = Rect.zero;
  Rect upperConstructionRect = Rect.zero;

  /// [getCentralConstructionRect] inflates [localButtonArrayRect] to a
  /// new height centered on the original.
  Rect get centralConstructionRectFromGuestRect {
    Rect rect = guestRect;
    return rect
        .inflateToHeight(math.max(0.0, rect.height - rect.shortestSide))
        .shift(offset ?? Offset.zero);
  }

  /// [getLowerConstructionRect] generates a construction rect below the
  /// centre of [ButtonArrayRect] to be used for calculating [deltaX].
  Rect get lowerConstructionRectFromGuestRect {
    //  Inflate [rect] to a new height centered on the original Rect.
    Rect rect = guestRect.inflateToHeight(1.0 * guestRect.shortestSide);

    //  Calculate shift factor and apply to rect.
    double dy = (guestRect.height + rect.height - rect.shortestSide) / 2.0;
    // print('${guestRect.height/2}, ${rect.height}, ${rect.shortestSide}');
    // print(rect.shift(Offset(0.0, dy)));
    return rect.shift(Offset(0.0, dy)).shift(offset ?? Offset.zero);
  }

  /// [getUpperConstructionRect] generates a construction rect above the
  /// centre of [ButtonArrayRect] to be used for calculating [deltaX].
  Rect get upperConstructionRectFromGuestRect {
    //  Inflate [rect] to a new height centered on original Rect.
    Rect rect = guestRect.inflateToHeight(1.0 * guestRect.shortestSide);

    //  Calculate shift factor and apply to rect.
    double dy = (guestRect.height + rect.height - rect.shortestSide) / 2.0;
    return rect.shift(Offset(0.0, -dy)).shift(offset ?? Offset.zero);
  }

  /// [getDeltaX] calculates the displacement to apply to
  /// [ListViewSettingsPageListTile] as it passes [buttonArrayRect].
  double getDeltaX(double scrollPosition) {
    Rect tmpRect= rect.shift(Offset(0.0,-scrollPosition));

    //  Default value is no displacement.
    double deltaX = 0.0;
    if (guestRect != null) {
      late double y;
      //  Determine which method to use for calculating [deltaX].
      if (upperConstructionRect.boundsContain(tmpRect.bottomLeft) ||
          upperConstructionRect.boundsContain(tmpRect.bottomRight)) {
        y = upperConstructionRect.bottom - tmpRect.bottom;
        deltaX = guestRect.width - getDeltaXFromPosition(upperConstructionRect, y);
        print('y1 = $y');
        print('upperConstructionRect.top = ${upperConstructionRect.top}');
        print('upperConstructionRect.bottom = ${upperConstructionRect.bottom}');
        print('tmpRect.top = ${tmpRect.top}');
        print('tmpRect.bottom = ${tmpRect.bottom}');
      } else if (lowerConstructionRect.boundsContain(tmpRect.topLeft) ||
          lowerConstructionRect.boundsContain(tmpRect.topRight)) {
        y = lowerConstructionRect.bottom - tmpRect.top;
        // print('y = $y');
        // print('scrollPosition = $scrollPosition');
        // print('rect = $rect');
        deltaX = getDeltaXFromPosition(lowerConstructionRect, y);
        print('y2 = $y');
        print('lowerConstructionRect.top = ${lowerConstructionRect.top}');
        print('lowerConstructionRect.bottom = ${lowerConstructionRect.bottom}');
        print('tmpRect.top = ${tmpRect.top}');
        print('tmpRect.bottom = ${tmpRect.bottom}');
      } else if (centralConstructionRect.overlaps(tmpRect)) {
        //  [guestRect] overlaps with [upperConstructionRect].
        deltaX = guestRect.width;
      }
    }
    return deltaX;
  }

  /// [getDeltaXFromLowerConstructionRect] calculates the amount,
  /// [deltaX], to decrease the width of [ListViewSettingsPageListTile] from its
  /// maximum value in order to accommodate [ButtonArray].
  ///
  /// The maximum value of [deltaX] corresponds to when [ListViewSettingsPageListTile]
  /// is alongside [ButtonArray].
  ///
  /// [deltaX] is a smooth function of [y], the vertical displacement between
  /// the bottom edge of [lowerConstructionRect] and the top edge of
  /// [ListViewSettingsPageListTile]. For the purpose of calculating deltaX, the origin
  /// is taken to be the bottom left corner of [lowerConstructionRect].
  ///
  /// The bottom corner follows a path that is made up of a curved, circular
  /// section, a line segment and a curved section. The line passes through
  /// (a,b), the coordinates of the centre point of [lowerConstructionRect],
  /// and is tangent to the curve at (xCrit, yCrit).
  double getDeltaXFromPosition(Rect rect, double y) {
    //  [r] is the radius of the curved path section.
    double r = rect.shortestSide / 2.0;

    //  ([a], [b]) are the coordinates of the point of symmetry, taken to
    //  be the centre of [lowerConstructionRect]. Relative to the
    //  bottom left corner of [lowerConstructionRect], [a] and [b] have
    //  the values as follows.
    double a = rect.width / 2.0;
    double b = rect.height / 2.0;

    //  In order to avoid generating complex numbers aa + bb - 2ra must be
    //  greater than zero.
    assert(a * a + b * b - 2 * r * a >= 0,
    'SettingsPageListTileBorder, getDeltaXFromLowerConstructionRect: '
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
    if (y <= yCrit) {
      //  The bottom left corner of [lowerConstructionRect] is the origin
      //  of the bounding box.
      //
      //  (xCrit,yCrit) is the point where the curve joins to the line segment.
      //  (r,0) is the centre of the circle. To get deltaX invert
      //      (x - r)^2 + (y - 0)^2 = r^2,
      //  taking the negative root.
      deltaX = r - math.sqrt(r * r - y * y);
    } else if (y <= 2 * b - yCrit) {
      //  The bottom left corner of [lowerConstructionRect] is the origin
      //  of the bounding box.
      //
      //  By symmetry, the line segment joins (xCrit,yCrit) to
      //  (2a - xCrit,2b - yCrit). To get the equation for deltaX invert
      //      (x - xCrit) / (y - yCrit)
      //          = (2a - xCrit - xCrit) / (2b - yCrit - yCrit),
      //  which just equates gradients.
      deltaX = xCrit + (y - yCrit) * (a - xCrit) / (b - yCrit);
    } else if (y <= 2 * b) {
      //  The bottom left corner of [lowerConstructionRect] is the origin
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
      'SettingsPageListTileBorder, getDeltaXFromLowerConstructionRect: '
          'error, invalid y-value.');
    }
    return deltaX;
  }

  @override
  Widget build(BuildContext context) {
    //  Build [SettingsPageListTileFromContainer] each time
    //  [SettingsPageContents] is scrolled.
    return ValueListenableBuilder<double>(
      valueListenable:
          DataNotifier.of(context, ValueKey('scrollController')).data,
      builder: (BuildContext context, double value, __) {
        return Container(
          //  Draw bounding box around [SettingsPageListTile].
          decoration: BoxDecoration(
            border: AppSettings.drawLayoutBounds
                ? Border.all(width: 0.0, color: Colors.redAccent)
                : null,
          ),
          // margin: EdgeInsets.only(left: (index == 0 ? getDeltaX(value) : 0.0)),
          margin: EdgeInsets.only(left: getDeltaX(value)),
          height: height,
          child: Container(
            key: UniqueKey(),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.5),
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: Text('Test...$index'),
          ),
        );
      },
    );
  }
}
