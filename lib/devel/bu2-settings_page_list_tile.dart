//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/app_settings_data.dart';
import 'package:kar_kam/boxed_container.dart';
import 'package:kar_kam/lib/alignment_extension.dart';
import 'package:kar_kam/lib/data_store.dart';
import 'package:kar_kam/lib/rect_extension.dart';

/// [SettingsPageListTile] implements a ListTile effect that is able to
/// slide around objects on the screen bounded by [guestRect].
class SettingsPageListTile extends StatelessWidget {
  SettingsPageListTile({
    Key? key,
    required this.basePageViewRect,
    required this.guestRect,
    required this.height,
    required this.index,
    this.leading,
  }) : super(key: key) {
    //  Create [initRect], a representation of [SettingsPageListTile]
    //  at the correct location, from [basePageViewRect].
    initRect = basePageViewRect
        .inflateToHeight(height)
        .moveTopLeftTo(basePageViewRect.topLeft)
        .translate(0, height * index);

    //  Generate construction Rects.
    centralConstrRect = centralConstructionRect;
    lowerConstrRect = lowerConstructionRect;
    upperConstrRect = upperConstructionRect;

    //  Upload the radius of curvature associated with the path that
    //  defines how [SettingsPageListTile] slides around [guestRect].
    if (guestRect != null) r = guestRect!.shortestSide / 2;
  }

  /// The visible area on screen that contains [SettingsPageContents].
  final Rect basePageViewRect;

  /// The Rect on screen which [SettingsPageListTile] will avoid when scrolling.
  final Rect? guestRect;

  /// The height of the absolute bounding box for [SettingsPageListTile].
  final double height;

  /// Unique identifier for [SettingsPageListTile].
  final int index;

  /// A widget to display before the title.
  final Widget? leading;

  /// A construction Rect situated directly between [upperConstrRect]
  /// and [lowerConstrRect] having the same width as [guestRect].
  Rect? centralConstrRect;

  /// A representation of [SettingsPageListTile] at its initial location.
  late Rect initRect;

  /// The construction Rect that overlaps with [guestRect.bottomLeft] and
  /// [guestRect.bottomRight] and has the same width as [guestRect].
  Rect? lowerConstrRect;

  /// The radius associated with the curved path segment that defines
  /// the sliding motion of [SettingsPageListTile].
  double r = 0.0;

  /// The construction Rect that overlaps with [guestRect.topLeft] and
  /// [guestRect.topRight] and has the same width as [guestRect].
  Rect? upperConstrRect;

  /// Getter for [centralConstrRect].
  Rect? get centralConstructionRect {
    //  Inflates [guestRect] to a new height centered on the original.
    return guestRect?.inflateToHeight(math.max(0.0,
        guestRect != null ? guestRect!.height - guestRect!.shortestSide : 0.0));
  }

  /// Getter for [lowerConstrRect].
  Rect? get lowerConstructionRect {
    if (guestRect != null) {
      //  Inflate [guestRect] to a new height centered on the original, then
      //  move it so that its top left corner is coincident with
      //  [guestRect.bottomLeft], finally translate it upwards by
      //  [guestRect!.shortestSide].
      return guestRect!
          .inflateToHeight(1.0 * guestRect!.shortestSide)
          .moveTopLeftTo(guestRect!.bottomLeft)
          .translate(0.0, -guestRect!.shortestSide / 2);
    } else
      return null;
  }

  /// Getter for [upperConstrRect].
  Rect? get upperConstructionRect {
    if (guestRect != null) {
      //  Inflate [guestRect] to a new height centered on the original, then
      //  move it so that its bottom left corner is coincident with
      //  [guestRect.topLeft], finally translate it downwards by
      //  [guestRect!.shortestSide].
      return guestRect!
          .inflateToHeight(1.0 * guestRect!.shortestSide)
          .moveBottomLeftTo(guestRect!.topLeft)
          .translate(0.0, guestRect!.shortestSide / 2);
    } else
      return null;
  }

  /// [getDeltaX] calculates the horizontal displacement to apply to
  /// [SettingsPageListTile] as it passes [guestRect].
  double getDeltaX(double scrollPosition) {
    //  The output variable.
    double? xP;

    //  A copy of [initRect] that has the correct current y-value calculated
    //  from [scrollPosition].
    Rect rect = initRect.shift(Offset(0.0, -scrollPosition));

    //  Determine which method to use for calculating [xP].
    if (guestRect != null) {
      if (lowerConstrRect!.boundsContain(rect.topLeft) ||
          lowerConstrRect!.boundsContain(rect.topRight)) {
        //  Top of [rect] is overlapped by [lowerConstrRect].
        //  Calculate y relative to [lowerConstrRect!.bottom]; the positive
        //  y-axis points vertically upwards in this function.
        double y = lowerConstrRect!.bottom - rect.top;

        //  Calculate xP.
         xP = getXFromY(lowerConstrRect!, y);
      } else if (upperConstrRect!.boundsContain(rect.bottomLeft) ||
          upperConstrRect!.boundsContain(rect.bottomRight)) {
        //  Bottom of [rect] is overlapped by [upperConstrRect].
        //  Calculate y relative to [upperConstrRect!.bottom]; the positive
        //  y-axis points vertically upwards in this function.
        double y = upperConstrRect!.bottom - rect.bottom;

        //  Calculate xP and subtract it from guestRect!.width because
        //  it is the opposite to the above procedure.
         xP = getXFromY(upperConstrRect!, y);
         xP = guestRect!.width - xP;
      } else if (centralConstrRect!.overlaps(rect)) {
        //  [centralConstrRect] overlaps with [rect].
         xP = guestRect!.width;
      }
    }

    //  Return [xP] or zero, but not null.
    return  xP ?? 0.0;
  }

  /// [getXFromY] calculates the value to subtract from the width
  /// of [SettingsPageListTile] in order to accommodate [ButtonArray].
  ///
  /// The maximum value of [xP] corresponds to when [SettingsPageListTile]
  /// is alongside [ButtonArray].
  ///
  /// [xP] is a smooth function of [y], the vertical displacement between
  /// the bottom edge of [lowerConstrRect] and the top edge of
  /// [SettingsPageListTile]. For the purpose of calculating xP, the origin
  /// is taken to be the bottom left corner of [lowerConstrRect].
  ///
  /// The bottom corner follows a path that is made up of a curved, circular
  /// section, a line segment and a curved section. The line passes through
  /// (a, b), the coordinates of the centre point of [lowerConstrRect],
  /// and is tangent to the curve at (xCrit, yCrit).
  double getXFromY(Rect rect, double y) {
    //  ([a], [b]) are the coordinates of the point of symmetry, taken to
    //  be the centre of [rect].
    //
    //  Relative to the bottom left corner of [rect], [a] and [b] have
    //  the values as follows.
    double a = rect.width / 2.0;
    double b = rect.height / 2.0;

    //  P is the point on the path that determines the sliding motion
    //  of [SettingsPageListTile]. It has coordinates (xP, yP) relative to
    //  the bottom left corner of Rect.
    //
    //  P sits on radii associated with the curved path segment and
    //  [SettingsPageLitTile] curved corner. Both radii lie on the same line.
    double yP = (y + AppSettingsOrig.settingsPageListTileRadius) * r / (r + AppSettingsOrig.settingsPageListTileRadius);

    //  In order to avoid generating complex numbers aa + bb - 2ra > 0.
    assert(
        a * a + b * b - 2 * r * a >= 0,
        'SettingsPageListTile, get xPFromY: '
        'error, complex number generated by square root.');

    //  The negative square root is taken as otherwise, with (a,b) = (2r,r),
    //  the positive root implies a vertical line segment with yCrit < 0.
    double xCrit =
        (a * a + b * b - r * a - b * math.sqrt(a * a + b * b - 2 * r * a)) *
            r /
            (b * b + (a - r) * (a - r));

    //  To get yCrit invert the equation of a circle,
    //      (x - r)^2 + (y - 0)^2 = r^2.
    double yCrit = math.sqrt(r * r - (xCrit - r) * (xCrit - r));

    //  Calculate  xP.
    double? xP;
    if (yP <= yCrit) {
      //  The bottom left corner of [lowerConstrRect] is the origin
      //  of the bounding box.
      //
      //  (xCrit, yCrit) is the point where the curve joins to the line segment.
      //  (r, 0) is the centre of the circle. To get  xP invert
      //      (x - r)^2 + (y - 0)^2 = r^2,
      //  taking the negative root.
       xP = r - math.sqrt(r * r - yP * yP);
       if (index == 8) {
         print('index = $index');
         print('a = $a');
         print('b = $b');
         print('r = $r');
         print('rr = ${AppSettingsOrig.settingsPageListTileRadius}');
         print('y = $y');
         print('yP = $yP');
         print('xP = $xP');
         print('\n');
       }
    } else if (yP <= 2 * b - yCrit) {
      //  The bottom left corner of [lowerConstrRect] is the origin
      //  of the bounding box.
      //
      //  By symmetry, the line segment joins (xCrit, yCrit) to
      //  (2a - xCrit, 2b - yCrit). To get the equation for xP invert
      //      (x - xCrit) / (y - yCrit)
      //          = (2a - xCrit - xCrit) / (2b - yCrit - yCrit),
      //  which just equates gradients.
       xP = xCrit + (yP - yCrit) * (a - xCrit) / (b - yCrit);
    } else if (yP <= 2 * b) {
      //  The bottom left corner of [lowerConstrRect] is the origin
      //  of the bounding box.
      //
      //  (2a - xCrit,2b - yCrit is the point where the curve joins to the
      //  line segment. (2a - r,2b) is the centre of the circle. To get
      //   xP invert
      //      (x - (2a - r))^2 + (y - 2b)^2 = r^2
      //  taking the positive root.
       xP = (2 * a - r) + math.sqrt(r * r - (yP - 2 * b) * (yP - 2 * b));
    } else {
      assert(
          false,
          'SettingsPageListTile, get xPFromY: '
          'error, invalid yP-value.');
    }
    return  xP ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    //  Build [SettingsPageListTile] each time the scroll position changes..
    return ValueListenableBuilder<double>(
      valueListenable:
          GlobalData.of(context, ValueKey('scrollPosition')).data,
      builder: (BuildContext context, double value, __) {
        //  Calculate the degree of indentation/horizontal shrinkage to
        //  be applied to this instance of [SettingsPageListTile].
        double  xP = getDeltaX(value);

        //  The topmost instance of Container, with the use of  xP to
        //  define margin, implements the variable width settings panel.
        return BoxedContainer(
          margin: AppSettingsOrig.buttonAlignment.isLeft
              ? EdgeInsets.only(left:  xP)
              : EdgeInsets.only(right:  xP),
          height: height,
          padding: AppSettingsOrig.settingsPageListTilePadding,
          child: BoxedContainer(
            borderRadius: AppSettingsOrig.settingsPageListTileRadius,
            color: Colors.pink[50],
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      BoxedContainer(
                        child: leading,
                      ),
                      Expanded(
                        child: BoxedContainer(
                          child: Text(
                            '$index. Some very, very, very, very, very, very, very, very, very, very, very, verylongtext!',
                            maxLines: 1,
                            softWrap: false,
                            // overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: BoxedContainer(
                    width: 2 * AppSettingsOrig.settingsPageListTileIconSize,
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSettingsOrig.settingsPageListTileRadius),
                      //  https://stackoverflow.com/questions/62782165/how-to-create-this-linear-fading-opacity-effect-in-flutter-for-android
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [
                          0.0,
                          0.5,
                          1.0,
                        ],
                        colors: [
                          //create 2 white colors, one transparent
                          Colors.pink[50]!.withOpacity(0.0),
                          Colors.pink[50]!.withOpacity(1.0),
                          Colors.pink[50]!.withOpacity(1.0),
                        ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}