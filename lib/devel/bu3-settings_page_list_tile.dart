//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/app_settings_orig.dart';
import 'package:kar_kam/boxed_container.dart';
import 'package:kar_kam/lib/alignment_extension.dart';
import 'package:kar_kam/lib/data_store.dart';
import 'package:kar_kam/lib/rect_extension.dart';

/// [SettingsPageListTile] implements a ListTile effect that is able to
/// slide around objects bounded by [guestRect].
class SettingsPageListTile extends StatelessWidget {
  SettingsPageListTile({
    Key? key,
    required this.basePageViewRect,
    required this.guestRect,
    required this.height,
    required this.index,
    this.leading,
  }) : super(key: key) {
    //  Create [hostRect], a representation of [SettingsPageListTile]
    //  at the correct location, from [basePageViewRect].
    hostRect = basePageViewRect
        .inflateToHeight(height)
        .moveTopLeftTo(basePageViewRect.topLeft)
        .translate(0, height * index);

    //  Generate construction Rects.
    centreRect = centreConstructionRect;
    lowerRect = lowerConstructionRect;
    upperRect = upperConstructionRect;

    //  Upload the radius of curvature associated with the path that
    //  defines how [SettingsPageListTile] slides around [guestRect].
    if (guestRect != null) pathRadius = guestRect!.shortestSide / 2;

    //  Upload the [AppSettings.settingsPageListTileRadius]
    //  and [AppSettings.settingsPageListTilePadding] combined corer radius
    cornerRadius = AppSettingsOrig.settingsPageListTileRadius +
        AppSettingsOrig.settingsPageListTilePadding;
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

  /// A construction Rect situated directly between [rectU]
  /// and [rectL] having the same width as [guestRect].
  Rect? centreRect;

  /// A representation of [SettingsPageListTile] at its initial location.
  late Rect hostRect;

  /// The construction Rect that overlaps with [guestRect.bottomLeft] and
  /// [guestRect.bottomRight] and has the same width as [guestRect].
  Rect? lowerRect;

  /// The combined corner radius derived from
  /// [AppSettingsOrig.settingsPageListTileRadius] and
  /// [AppSettingsOrig.settingsPageListTilePadding].
  double cornerRadius = 0.0;

  /// The radius associated with the curved path segment that defines
  /// the sliding motion of [SettingsPageListTile].
  double pathRadius = 0.0;

  /// The construction Rect that overlaps with [guestRect.topLeft] and
  /// [guestRect.topRight] and has the same width as [guestRect].
  Rect? upperRect;

  /// Getter for [centreRect].
  Rect? get centreConstructionRect {
    //  Inflates [guestRect] to a new height centered on the original.
    return guestRect?.inflateToHeight(math.max(0.0,
        guestRect != null ? guestRect!.height - guestRect!.shortestSide : 0.0));
  }

  /// Getter for [lowerRect].
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

  /// Getter for [upperRect].
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
    double deltaX = 0.0;

    //  Generate a copy of [hostRect] and translate it vertically so that
    //  it has the correct current y-value for [scrollPosition].
    Rect rect = hostRect.shift(Offset(0.0, -scrollPosition));

    //  Determine which method to use for calculating [deltaX].
    if (guestRect != null) {
      if (lowerRect!.inflateHeight(cornerRadius).boundsContain(rect.topLeft) ||
          lowerRect!.inflateHeight(cornerRadius).boundsContain(rect.topRight)) {
        //  A stretched version of [lowerRect] overlaps the top of [rect].
        //  A stretched version is used in order to account for
        //  [SettingsPageListTile] having corners.

        //  Calculate the y-value for rect.top relative to [lowerRect!.bottom].
        //  The positive y-axis points vertically upwards in this function.
        double y = lowerRect!.bottom - rect.top;

        //  Calculate deltaX.
        deltaX = getXFromY(lowerRect!, y);
      } else if (upperRect!
              .inflateHeight(cornerRadius)
              .boundsContain(rect.bottomLeft) ||
          upperRect!
              .inflateHeight(cornerRadius)
              .boundsContain(rect.bottomRight)) {
        //  A stretched version of [upperRect] overlaps the bottom of [rect].
        //  A stretched version is used in order to account for
        //  [SettingsPageListTile] having corners.

        //  Bottom of [rect] is overlapped by [upperRect].
        //  Calculate y-value for rect.bottom relative to [upperRect!.bottom].
        //  The positive y-axis points vertically upwards in this function.
        double y = upperRect!.bottom - rect.bottom;

        //  Calculate deltaX and subtract it from guestRect!.width because
        //  it is the opposite to the above procedure.
        deltaX = getXFromY(upperRect!, y);
        deltaX = guestRect!.width - deltaX;
      } else if (centreRect!.overlaps(rect)) {
        //  [centreRect] overlaps with [rect].
        deltaX = guestRect!.width;
      }
    }
    return deltaX;
  }

  /// [getXFromY] calculates the value to subtract from the width
  /// of [SettingsPageListTile] in order to accommodate [ButtonArray].
  ///
  /// The point P, with coordinates (xP, yP), follows the path that
  /// determines how [SettingsPageListTile] slides past [guestRect].
  ///
  /// The maximum value of [xP] corresponds to when [SettingsPageListTile]
  /// is alongside [ButtonArray].
  ///
  /// [xP] is a smooth function of [y], the vertical displacement between
  /// the bottom edge of [lowerRect] and the top edge of
  /// [SettingsPageListTile]. For the purpose of calculating xP, the origin
  /// is taken to be the bottom left corner of [lowerRect].
  ///
  /// The bottom corner follows a path that is made up of a curved, circular
  /// section, a line segment and a curved section. The line passes through
  /// (a, b), the coordinates of the centre point of [lowerRect],
  /// and is tangent to the curve at (xCrit, yCrit).
  double getXFromY(Rect rect, double y) {
    //  ([a], [b]) are the coordinates of the point of symmetry, taken to
    //  be the centre of [rect].
    //
    //  Relative to the bottom left corner of [rect], [a] and [b] have
    //  the values as follows.
    double a = rect.width / 2.0;
    double b = rect.height / 2.0;

    //  In order to avoid generating complex numbers aa + bb - 2ra > 0.
    assert(a * a + b * b - 2 * pathRadius * a >= 0,
        'SettingsPageListTile, get xPFromY: '
        'error, complex number generated by square root.');

    //  The negative square root is taken as otherwise, with
    //      (a, b) = (2pathRadius, pathRadius),
    //  the positive root implies a vertical line segment with yCrit < 0.
    double xCrit = (a * a + b * b - pathRadius * a -
        b * math.sqrt(a * a + b * b - 2 * pathRadius * a)) *
          pathRadius / (b * b + (a - pathRadius) * (a - pathRadius));

    //  To get yCrit invert the equation of a circle,
    //      (x - r)^2 + (y - 0)^2 = r^2.
    double yCrit = math.sqrt(
        pathRadius * pathRadius - (xCrit - pathRadius) * (xCrit - pathRadius));

    double cosTheta = getCosTheta(y, yCrit, a, b);

    Offset? rP = getXpOnCurvedPathSegment(y);

    if (rP != null) {
      if (rP.dy <= yCrit) {
        return rP.dx;
      } else if (rP.dy <= 2 * b - yCrit) {
        rP = getXpOnLinearPathSegment(y, xCrit, yCrit, a, b);
        return rP.dx;
      } else if (rP.dy <= 2 * b) {
        return 2 * a - rP.dx;
      }
    }
    rP = getXpOnLinearPathSegment(y, xCrit, yCrit, a, b);
    if (rP.dy <)


    // //  P sits on radii associated with the curved path segment and
    // //  [SettingsPageLitTile] curved corner. Both radii lie on the same line.
    // //
    // //  When cornerRadius is zero yP = y.
    // double yP = (y + cornerRadius) * pathRadius / (pathRadius + cornerRadius);
    //
    // //  Calculate  xP.
    // double xP = 0.0;
    // if (yP <= yCrit) {
    //   //  The bottom left corner of [lowerRect] is the origin of the
    //   //  bounding box.
    //   //
    //   //  (xCrit, yCrit) is the point where the curve joins to the line segment.
    //   //  (pathRadius, 0) is the centre of the circle. To get xP invert
    //   //      (x - pathRadius)^2 + (y - 0)^2 = pathRadius^2,
    //   //  taking the negative root.
    //   xP = pathRadius - math.sqrt(pathRadius * pathRadius - yP * yP);
    //   if (index == 8) {
    //     print('index = $index');
    //     print('a = $a');
    //     print('b = $b');
    //     print('pathRadius = $pathRadius');
    //     print('cornerRadius = $cornerRadius');
    //     print('y = $y');
    //     print('yP = $yP');
    //     print('xP = $xP');
    //     print('\n');
    //   }
    // } else if (yP <= 2 * b - yCrit) {
    //   //  The bottom left corner of [lowerRect] is the origin of the
    //   //  bounding box.
    //   //
    //   //  By symmetry, the line segment joins (xCrit, yCrit) to
    //   //  (2a - xCrit, 2b - yCrit). To get the equation for xP invert
    //   //      (x - xCrit) / (y - yCrit)
    //   //          = (2a - xCrit - xCrit) / (2b - yCrit - yCrit),
    //   //  which just equates gradients.
    //   xP = xCrit + (yP - yCrit) * (a - xCrit) / (b - yCrit);
    // } else if (yP <= 2 * b) {
    //   //  The bottom left corner of [lowerRect] is the origin of
    //   //  the bounding box.
    //   //
    //   //  (2a - xCrit, 2b - yCrit) is the point where the curve joins to the
    //   //  line segment. (2a - pathRadius, 2b) is the centre of the circle. To get
    //   //  xP invert
    //   //      (x - (2a - pathRadius))^2 + (y - 2b)^2 = pathRadius^2
    //   //  taking the positive root.
    //   xP = (2 * a - pathRadius) +
    //       math.sqrt(pathRadius * pathRadius - (yP - 2 * b) * (yP - 2 * b));
    // } else {
    //   assert(
    //       false,
    //       'SettingsPageListTile, get xPFromY: '
    //       'error, invalid yP-value.');
    // }
    return xP;
  }

  double getCosTheta(y, yCrit, a, b) {
    double cosTheta = 1.0;
    double? yTmp;
    if (y <= pathRadius) {
      cosTheta = (y + cornerRadius) / (cornerRadius + pathRadius);
      yTmp = pathRadius * cosTheta
    }

    if (yTmp <= yCrit) return cosTheta;

    if (2 * b - y <= pathRadius) {
      cosTheta = (2 * b - y + cornerRadius) / (cornerRadius + pathRadius);
      yTmp = pathRadius * cosTheta
    }
    return cosTheta;
  }

  Offset? getXpOnCurvedPathSegment(y) {
    if (y + cornerRadius > cornerRadius + pathRadius) return null;
    double cosTheta = (y + cornerRadius) / (cornerRadius + pathRadius);
    return Offset(cosTheta, math.sqrt(1 - cosTheta * cosTheta)) * pathRadius;
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
        double xP = getDeltaX(value);

        //  The topmost instance of Container, with the use of  xP to
        //  define margin, implements the variable width settings panel.
        return BoxedContainer(
          margin: AppSettingsOrig.buttonAlignment.isLeft
              ? EdgeInsets.only(left: xP)
              : EdgeInsets.only(right: xP),
          height: height,
          padding: EdgeInsets.all(AppSettingsOrig.settingsPageListTilePadding),
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
                      borderRadius: BorderRadius.circular(
                          AppSettingsOrig.settingsPageListTileRadius),
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
                          ]),
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
