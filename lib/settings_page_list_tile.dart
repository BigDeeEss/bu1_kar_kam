//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/boxed_container.dart';
import 'package:kar_kam/lib/alignment_extension.dart';
import 'package:kar_kam/lib/data_notifier.dart';
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
    cornerRadius = AppSettings.settingsPageListTileRadius +
        AppSettings.settingsPageListTilePadding;
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
  /// [AppSettings.settingsPageListTileRadius] and
  /// [AppSettings.settingsPageListTilePadding].
  double cornerRadius = 0.0;

  /// The radius associated with the curved path segment that defines
  /// the sliding motion of [SettingsPageListTile].
  double pathRadius = 0.0;

  /// The construction Rect that overlaps with [guestRect.topLeft] and
  /// [guestRect.topRight] and has the same width as [guestRect].
  Rect? upperRect;

  /// Getter for [centreRect].
  Rect? get centreConstructionRect {
    //  Generates a Rect bounded by the bottom of [upperConstructionRect]
    //  and the top of [lowerConstructionRect].
    //  Returns null only if if [guestRect] is null.
    if (guestRect != null) {
      Rect uRect = upperConstructionRect!;
      Rect lRect = lowerConstructionRect!;

      //  Ensure that [lowerConstructionRect] and [upperConstructionRect]
      //  do not overlap.
      assert(
          !uRect.overlaps(lRect),
          'SettingsPageListTile, centreConstructionRect getter: error, '
          'lowerConstructionRect and upperConstructionRect overlap.');

      return uRect.bottomLeft & Size(lRect.right, lRect.top);
    } else {
      return null;
    }
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
      // .translate(0.0, -cornerRadius);
    } else {
      return null;
    }
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
      // .translate(0.0, cornerRadius);
    } else {
      return null;
    }
  }

  ///  [getOuterCosTheta] for points where yP lies on the curved path segment.
  double? getOuterCosTheta(double y) {
    double? sinTheta = getOuterSinTheta(y);
    double? cosTheta;
    if (sinTheta != null) {
      cosTheta = math.sqrt(1.0 - sinTheta * sinTheta);
    }
    return cosTheta;
  }

  ///  [getInnerCosTheta] for points where yP lies on the curved path segment.
  double? getInnerCosTheta(double y) {
    double? sinTheta = getInnerSinTheta(y);
    double? cosTheta;
    if (sinTheta != null) {
      cosTheta = math.sqrt(1.0 - sinTheta * sinTheta);
    }
    return cosTheta;
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
      if (lowerRect!
              .boundsContain(rect.translate(0.0, cornerRadius).topLeft) ||
          lowerRect!
              .boundsContain(rect.translate(0.0, cornerRadius).topRight)) {
        //  Use the y-value associated with [rect.top] relative to
        //  [lowerRect!.bottom], modified to account for [cornerRadius].
        //  The positive y-axis points vertically upwards in this function.
        double y = lowerRect!.bottom - rect.top;

        //  Calculate deltaX.
        deltaX = getXFromY(lowerRect!, y);
      } else if (upperRect!
              .boundsContain(rect.translate(0.0, -cornerRadius).bottomLeft) ||
          upperRect!
              .boundsContain(rect.translate(0.0, -cornerRadius).bottomRight)) {
        //  Use the y-value associated with [rect.bottom] relative to
        //  [upperRect!.bottom], modified to account for [cornerRadius].
        //  The positive y-axis points vertically upwards in this function.
        double y = upperRect!.bottom - rect.bottom;

        //  Calculate deltaX.
        deltaX = getXFromY(upperRect!, y);
        deltaX = guestRect!.width - deltaX;
      } else if (centreRect!.overlaps(rect)) {
        //  [centreRect] overlaps with [rect] so set maximum deltaX value.
        deltaX = guestRect!.width;
      }
    }
    // if (index == 10) {
    //   print('deltaX = $deltaX');
    // }
    return deltaX;
  }

  ///  [getOuterSinTheta] for points where yP lies on the curved path segment.
  ///  [getOuterSinTheta] returns null if [sinTheta] is not between -1 and 1.
  double? getOuterSinTheta(double y) {
    double sinTheta = (y + cornerRadius) / (cornerRadius + pathRadius);
    if (sinTheta.abs() <= 1.0) {
      return sinTheta;
    } else {
      return null;
    }
  }

  ///  [getInnerSinTheta] for points where yP lies on the curved path segment.
  ///  [getInnerSinTheta] returns null if [sinTheta] is not between -1 and 1.
  double? getInnerSinTheta(double y) {
    double sinTheta = (y - cornerRadius) / (pathRadius - cornerRadius);
    if (sinTheta.abs() <= 1.0) {
      return sinTheta;
    } else {
      return null;
    }
  }

  double getXFromY(Rect rect, double y) {
    //  S is the point of symmetry, taken to be the centre of [rect], with
    //  coordinates (xS, yS).
    //
    //  Relative to the bottom left corner of [rect], [xS] and [yS] have
    //  the values as follows.
    double xS = rect.width / 2.0;
    double yS = rect.height / 2.0;

    //  In order to avoid generating complex numbers aa + bb - 2ra > 0.
    assert(xS * xS + yS * yS - 2 * pathRadius * xS >= 0,
        'SettingsPageListTile, get xPFromY: '
        'error, complex number generated by square root.');

    //  The negative square root is taken as otherwise, with
    //      (xS, yS) = (2 * pathRadius, pathRadius),
    //  the positive root implies a vertical line segment with yCrit < 0.
    double xCrit = (xS * xS + yS * yS - pathRadius * xS -
        yS * math.sqrt(xS * xS + yS * yS - 2 * pathRadius * yS)) *
            pathRadius / (yS * yS + (xS - pathRadius) * (xS - pathRadius));

    //  To get yCrit invert the equation of a circle,
    //      (x - r)^2 + (y - 0)^2 = r^2.
    double yCrit = math.sqrt(
        pathRadius * pathRadius - (xCrit - pathRadius) * (xCrit - pathRadius));

    double cosThetaCrit = getOuterCosTheta(yCrit)!;
    double sinThetaCrit = getOuterSinTheta(yCrit)!;
    double y1 = (cornerRadius + pathRadius) * sinThetaCrit - cornerRadius;
    double y2 = 2 * yS - yCrit - (yCrit - y1);
    double y3 = 2 * yS - cornerRadius;
    double? xP;
    double yP = 0;
    double cosTheta = 0;
    double sinTheta = 0;

    if (y <= y1) {
      cosTheta = getOuterCosTheta(y)!;
      sinTheta = getOuterSinTheta(y)!;
      xP = pathRadius - (pathRadius * cosTheta! - (cornerRadius - cornerRadius * cosTheta));
      if (index == 10) print('test 1');
    } else if (y <= y2) {
      //  ToDo: implement line segment.
    //   xP = xCrit + (y - yCrit) * (xS - xCrit) / (yS - yCrit);
      if (index == 10) print('test 2');
    } else if (y <= y3) {
      //  ToDo: implement second curved path segment.
      cosTheta = getInnerCosTheta(2 * yS - y)!;
      // sinTheta = getInnerSinTheta(2 * yS - y)!;
      // xP = 2 * pathRadius - (pathRadius * cosTheta! - (cornerRadius - cornerRadius * cosTheta));
      xP = pathRadius + ((pathRadius) * cosTheta + (cornerRadius - cornerRadius * cosTheta));
    //   xP = pathRadius + pathRadius * cosTheta!;
      if (index == 10) print('test 3');
    } else {
      //  ToDo: implement check.
      // assert(false,
      //     'SettingsPageListTile, getXFromY: error, invalid y-value.');
    }

    if (index == 10) {
      print('cornerRadius = $cornerRadius');
      print('pathRadius = $pathRadius');
      print('y = $y');
      print('2 * yS - y = ${2 * yS - y}');
      print('sinThetaCrit = ${getOuterSinTheta(yCrit)}');
      print('sinTheta = ${getOuterSinTheta(y)}');
      print('cosTheta = ${getOuterCosTheta(y)}');
      // print('cosTheta = ${math.sqrt(1 - (getOuterSinTheta(y)! * getOuterSinTheta(y)!))}');
      print('cosThetaCrit = $cosThetaCrit');
      print('yS = $yS');
      print('yCrit = $yCrit');
      print('y1 = $y1');
      print('y2 = $y2');
      print('y3 = $y3');
      print('xP = $xP');
      print('y = ${(cornerRadius + pathRadius) * sinTheta - cornerRadius}');
      print('yP = ${(pathRadius) * sinTheta}');
    }

    return xP ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    //  Build [SettingsPageListTile] each time the scroll position changes..
    return ValueListenableBuilder<double>(
      valueListenable:
          DataNotifier.of(context, ValueKey('scrollPosition')).data,
      builder: (BuildContext context, double value, __) {
        //  Calculate the degree of indentation/horizontal shrinkage to
        //  be applied to this instance of [SettingsPageListTile].
        double xP = index == 10 ? getDeltaX(value) : 0;

        //  The topmost instance of Container, with the use of  xP to
        //  define margin, implements the variable width settings panel.
        return BoxedContainer(
          margin: AppSettings.buttonAlignment.isLeft
              ? EdgeInsets.only(left: xP)
              : EdgeInsets.only(right: xP),
          height: height,
          padding: EdgeInsets.all(AppSettings.settingsPageListTilePadding),
          child: BoxedContainer(
            borderRadius: AppSettings.settingsPageListTileRadius,
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
                    width: 2 * AppSettings.settingsPageListTileIconSize,
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          AppSettings.settingsPageListTileRadius),
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
