//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//  Import project-specific files.
import 'package:kar_kam/settings.dart';
import 'package:kar_kam/app_settings_data.dart';
import 'package:kar_kam/boxed_container.dart';
import 'package:kar_kam/lib/alignment_extension.dart';
import 'package:kar_kam/lib/data_store.dart';
import 'package:kar_kam/lib/double_extension.dart';
import 'package:kar_kam/lib/offset_extension.dart';
import 'package:kar_kam/lib/rect_extension.dart';

//  A temporary double for determining the slope of the connecting
//  straight line segment that constitutes the path by which tiles
//  pass around ButtonArray.
double sf = 1.125;

/// Implements a ListTile that is able to slide around [guestRect].
class SettingsPageListTile extends StatelessWidget {
  SettingsPageListTile({
    Key? key,
    required this.basePageViewRect,
    required this.guestRect,
    required this.height,
    required this.index,
    this.leading,
    this.onTap,
    this.trailing,
  }) : super(key: key) {
    //  Create a representation of SettingsPageListTile at the correct
    //  initial location.
    hostRect = basePageViewRect
        .inflateToHeight(height)
        .moveTopLeftTo(basePageViewRect.topLeft)
        .translate(0, height * index);

    //  Three Rect variables that define the characteristics of the path
    //  which determines the sliding motion of SettingsPageListTile.
    centreRect = centreConstructionRect;
    lowerRect = lowerConstructionRect;
    upperRect = upperConstructionRect;

    //  Upload the radius of curvature associated with the path that
    //  defines how SettingsPageListTile slides around guestRect.
    if (guestRect != null) pathRadius = guestRect!.shortestSide / 2;

    //  Upload the AppSettings.settingsPageListTileRadius
    //  and AppSettings.settingsPageListTilePadding combined corner radius.
    cornerRadius = AppSettingsOrig.settingsPageListTileRadius +
        AppSettingsOrig.settingsPageListTilePadding;

    // Calculate xPMax from basePageViewRect.
    xPMax = basePageViewRect.width - 3 * AppSettingsOrig.buttonRadius;
  }

  /// The visible area on screen that contains [SettingsPageContents].
  final Rect basePageViewRect;

  /// The Rect on screen which [SettingsPageListTile] will avoid when scrolling.
  final Rect? guestRect;

  /// The height of the absolute bounding box for [SettingsPageListTile].
  final double height;

  /// Unique identifier for [SettingsPageListTile]. This is a temporary measure
  /// which will be replaced by a variable tile height at a later stage.
  final int index;

  /// A widget to display on the left within [SettingsPageListTile].
  final Widget? leading;

  /// A gesture detection callback that implements the functionality
  /// associated with [SettingsPageListTile].
  final GestureTapCallback? onTap;

  /// A widget to display on the right within [SettingsPageListTile].
  final Widget? trailing;

  /// A construction Rect situated directly between [upperRect]
  /// and [lowerRect] having the same width as [guestRect].
  Rect? centreRect;

  /// A representation of [SettingsPageListTile] at its initial location.
  late Rect hostRect;

  /// The construction Rect that overlaps with [guestRect.bottomLeft] and
  /// [guestRect.bottomRight] and has the same width as [guestRect].
  Rect? lowerRect;

  /// A combined corner radius using [AppSettingsOrig.settingsPageListTileRadius]
  /// and [AppSettingsOrig.settingsPageListTilePadding].
  double cornerRadius = 0.0;

  /// The radius associated with the curved path segment that defines
  /// the sliding motion of [SettingsPageListTile].
  double pathRadius = 0.0;

  /// The construction Rect that overlaps with [guestRect.topLeft] and
  /// [guestRect.topRight] and has the same width as [guestRect].
  Rect? upperRect;

  /// The maximum xP before the Opacity widget hides [SettingsPageListTile].
  late double xPMax;

  /// Getter for [centreRect].
  Rect? get centreConstructionRect {
    //  Generates a Rect bounded by the bottom of upperConstructionRect
    //  and the top of lowerConstructionRect.
    //
    //  Returns null only if guestRect is null.
    if (guestRect != null) {
      Rect uRect = upperConstructionRect!;
      Rect lRect = lowerConstructionRect!;

      //  Ensure that lowerConstructionRect and upperConstructionRect
      //  do not overlap.
      assert(
          !uRect.overlaps(lRect),
          'SettingsPageListTile, get centreConstructionRect: error, '
          'lRect and uRect overlap.');

      //  Create an Offset that represents the diagonal displacement
      //  between corresponding end offsets on lRect and uRect.
      //
      //  Recall that the positive y direction is vertically down the screen.
      //
      //  Use this Offset to generate a Rect.
      Offset offset = Offset.zero;
      if (AppSettingsOrig.buttonAlignment.y > 0) {
        offset = lRect.bottomRight - uRect.bottomLeft;

        //  Convert offset to a Size and then construct output value.
        return uRect.bottomLeft & offset.toSize;
      } else {
        offset = lRect.topRight - uRect.topLeft;

        //  Convert offset to a Size and then construct output value.
        return uRect.topLeft & offset.toSize;
      }
    } else {
      return null;
    }
  }

  /// Getter for [lowerRect].
  Rect? get lowerConstructionRect {
    if (guestRect != null) {
      //  Inflate guestRect to a new height centered on the original, then
      //  move it so that its top left corner is coincident with
      //  guestRect.bottomLeft, finally translate it upwards by
      //  guestRect!.shortestSide.
      return guestRect!
          .inflateToHeight(sf * guestRect!.shortestSide)
          .moveTopLeftTo(guestRect!.bottomLeft)
          .translate(0.0, -guestRect!.shortestSide / 2);
    } else {
      return null;
    }
  }

  /// Getter for [upperRect].
  Rect? get upperConstructionRect {
    if (guestRect != null) {
      //  Inflate guestRect to a new height centered on the original, then
      //  move it so that its bottom left corner is coincident with
      //  guestRect.topLeft, finally translate it downwards by
      //  guestRect!.shortestSide.
      return guestRect!
          .inflateToHeight(sf * guestRect!.shortestSide)
          .moveBottomLeftTo(guestRect!.topLeft)
          .translate(0.0, guestRect!.shortestSide / 2);
    } else {
      return null;
    }
  }

  /// A [cosTheta] getter that depends on whether [SettingsPageListTile]
  /// overlaps (i = 1) or not (i = -1) [pathRadius].
  double? getCosTheta(double y, int i) {
    double? sinTheta = getSinTheta(y, i);

    if (sinTheta != null) {
      return (1 - sinTheta * sinTheta).sqrt;
    }
    return null;
  }

  /// Calculates the horizontal displacement to apply to [SettingsPageListTile]
  /// as it passes [guestRect].
  double getDeltaX(double scrollPosition) {
    //  The output variable.
    double deltaX = 0.0;

    //  Generate a copy of hostRect and translate it vertically so that
    //  it has the correct current y-value for scrollPosition.
    Rect rect = hostRect.shift(Offset(0.0, -scrollPosition));

    //  Determine which method to use for calculating deltaX.
    if (guestRect != null) {
      if (centreRect!.inflateHeight(-cornerRadius).overlaps(rect)) {
        //  centreRect overlaps with rect so set maximum deltaX value.
        deltaX = guestRect!.width;
      } else if (lowerRect!
              .boundsContain(rect.translate(0.0, cornerRadius).topLeft) ||
          lowerRect!
              .boundsContain(rect.translate(0.0, cornerRadius).topRight)) {
        //  Use the y-value associated with rect.top relative to
        //  lowerRect!.bottom, modified to account for cornerRadius.
        //
        //  The positive y-axis points vertically upwards in this function.
        double y = rect.top - lowerRect!.top;

        //  Calculate deltaX.
        deltaX = getXFromY(lowerRect!, y);
        deltaX = guestRect!.width - deltaX;
      } else if (upperRect!
              .boundsContain(rect.translate(0.0, -cornerRadius).bottomLeft) ||
          upperRect!
              .boundsContain(rect.translate(0.0, -cornerRadius).bottomRight)) {
        //  Use the y-value associated with rect.bottom relative to
        //  upperRect!.bottom, modified to account for cornerRadius.
        //
        //  The positive y-axis points vertically upwards in this function.
        double y = upperRect!.bottom - rect.bottom;

        //  Calculate deltaX.
        deltaX = getXFromY(upperRect!, y);
        deltaX = guestRect!.width - deltaX;
      }
    }
    return deltaX;
  }

  /// [getInnerCosTheta] for points where [yP] lies on the curved path segment.
  ///
  /// [getInnerCosTheta] returns null if [getCosTheta] is not between -1 and 1.
  ///
  /// [getInnerCosTheta] is used when [SettingsPageListTile] overlaps
  /// the radius of curvature associated with the curved path segment.
  double? getInnerCosTheta(double y) => getCosTheta(y, -1);

  /// [getInnerSinTheta] for points where [yP] lies on the curved path segment.
  ///
  /// [getInnerSinTheta] returns null if [getSinTheta] is not between -1 and 1.
  ///
  /// [getInnerSinTheta] is used when [SettingsPageListTile] overlaps
  /// the radius of curvature associated with the curved path segment.
  double? getInnerSinTheta(double y) => getSinTheta(y, -1);

  /// [getOuterCosTheta] for points where [yP] lies on the curved path segment.
  ///
  /// [getOuterCosTheta] returns null if [getCosTheta] is not between -1 and 1.
  ///
  /// [getOuterCosTheta] is used when [SettingsPageListTile] DOES NOT overlap
  /// the radius of curvature associated with the curved path segment.
  double? getOuterCosTheta(double y) => getCosTheta(y, 1);

  /// [getOuterSinTheta] for points where [yP] lies on the curved path segment.
  ///
  /// [getOuterSinTheta] returns null if [getSinTheta] is not between -1 and 1.
  ///
  /// [getOuterSinTheta] is used when [SettingsPageListTile] DOES NOT overlap
  /// the radius of curvature associated with the curved path segment.
  double? getOuterSinTheta(double y) => getSinTheta(y, 1);

  /// A [sinTheta] getter that depends on whether [SettingsPageListTile]
  /// overlaps (i = 1) or not (i = -1) [pathRadius].
  double? getSinTheta(double y, int i) {
    //  Check value of i -- it must be +1 or -1.
    assert(i.abs() == 1, 'SettingsPageListTile, getSinTheta: invalid i value.');

    double sinTheta = (y + i * cornerRadius) / (pathRadius + i * cornerRadius);

    if (sinTheta.abs() <= 1.0) {
      return sinTheta;
    } else {
      return null;
    }
  }

  double getXFromY(Rect rect, double y) {
    //  S is the point of symmetry, taken to be the centre of rect, with
    //  coordinates (xS, yS).
    //
    //  Relative to the bottom left corner of rect, xS and yS have
    //  the values as follows.
    double xS = rect.width / 2.0;
    double yS = rect.height / 2.0;

    //  In order to avoid generating complex numbers aa + bb - 2ra > 0.
    assert(
        xS * xS + yS * yS - 2 * pathRadius * xS >= 0,
        'SettingsPageListTile, get xPFromY: '
        'error, complex number generated by square root.');

    //  The negative square root is taken as otherwise, with
    //      (xS, yS) = (2 * pathRadius, pathRadius),
    //  the positive root implies a vertical line segment with yCrit < 0.
    double xCrit = (xS * xS +
            yS * yS -
            pathRadius * xS -
            yS * math.sqrt(xS * xS + yS * yS - 2 * pathRadius * xS)) *
        pathRadius /
        (yS * yS + (xS - pathRadius) * (xS - pathRadius));

    //  To get yCrit invert the equation of a circle,
    //      (x - r)^2 + (y - 0)^2 = r^2.
    double yCrit = math.sqrt(
        pathRadius * pathRadius - (xCrit - pathRadius) * (xCrit - pathRadius));

    double outerCosThetaCrit = getOuterCosTheta(yCrit)!;
    double outerSinThetaCrit = getOuterSinTheta(yCrit)!;
    double innerCosThetaCrit = getInnerCosTheta(yCrit)!;
    double innerSinThetaCrit = getInnerSinTheta(yCrit)!;
    double y1 = (cornerRadius + pathRadius) * outerSinThetaCrit - cornerRadius;
    double x1 = pathRadius -
        pathRadius * outerCosThetaCrit +
        (cornerRadius - cornerRadius * outerCosThetaCrit);
    double y2 = 2 * yS -
        (pathRadius * innerSinThetaCrit +
            (cornerRadius - cornerRadius * innerSinThetaCrit));
    double x2 = 2 * xS -
        pathRadius +
        pathRadius * innerCosThetaCrit +
        (cornerRadius - cornerRadius * innerCosThetaCrit);
    double y3 = 2 * yS - cornerRadius;
    double? xP;
    double cosTheta = 0;

    if (y <= y1) {
      cosTheta = getOuterCosTheta(y)!;
      xP = pathRadius -
          (pathRadius * cosTheta - (cornerRadius - cornerRadius * cosTheta));
    } else if (y <= y2) {
      xP = x1 + (y - y1) * (x2 - x1) / (y2 - y1);
    } else if (y <= y3) {
      cosTheta = getInnerCosTheta(2 * yS - y)!;
      xP = 2 * xS -
          pathRadius +
          ((pathRadius) * cosTheta + (cornerRadius - cornerRadius * cosTheta));
    } else {
      assert(false, 'SettingsPageListTile, getXFromY: error, invalid y-value.');
    }
    return xP ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    //  Get AppSettingsData held by GetIt in main.
    SettingsService appSettings = GetIt.instance<SettingsService>();

    //  Build SettingsPageListTile each time the scroll position changes..
    return ValueListenableBuilder<double>(
      valueListenable: DataStore.of<ValueNotifier<double>>(
              context, const ValueKey('scrollPosition'))
          .data,
      builder: (BuildContext context, double value, __) {
        //  Calculate the degree of indentation/horizontal shrinkage to
        //  be applied to this instance of SettingsPageListTile.
        double xP = getDeltaX(value);

        //  Use an Opacity widget to implement a vanishing SettingsPageListTile
        //  for when the space between guestRect and the edge of the screen
        //  is insufficient.
        return Opacity(
          opacity: (xP > xPMax) ? 0.0 : 1.0,
          //  The topmost instance of Container, with the use of xP to
          //  define margin, implements the variable width settings panel.
          child: BoxedContainer(
            margin: AppSettingsOrig.buttonAlignment.isLeft
                ? EdgeInsets.only(left: xP)
                : EdgeInsets.only(right: xP),
            height: height,
            padding: EdgeInsets.all(AppSettingsOrig.settingsPageListTilePadding),
            child: InkWell(
              onTap: onTap,
              child: BoxedContainer(
                borderRadius: AppSettingsOrig.settingsPageListTileRadius,
                color: Colors.pink[200],
                child: Row(
                  children: <Widget>[
                    BoxedContainer(
                      child: leading,
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: BoxedContainer(
                              child: Text(
                                '$index. Some very, very, very, very, very, very, very, very, very, very, very, verylongtext!',
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                          ),
                          //  The following widget is either an instance of Align,
                          //  in which case it implements a fade effect for the
                          //  Text widget, or Container().
                          appSettings.settingsPageListTileFadeEffect ? Align(
                            alignment: Alignment.centerRight,
                            child: BoxedContainer(
                              width: AppSettingsOrig.settingsPageListTileIconSize,
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
                                    Colors.pink[200]!.withOpacity(0.0),
                                    Colors.pink[200]!.withOpacity(1.0),
                                    Colors.pink[200]!.withOpacity(1.0),
                                  ],
                                ),
                              ),
                            ),
                          ) : Container(),
                        ],
                      ),
                    ),
                    BoxedContainer(
                      child: trailing,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
