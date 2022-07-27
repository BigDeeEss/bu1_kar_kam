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
/// slide around objects on the screen bounded by [guestRect].
class SettingsPageListTile extends StatelessWidget {
  SettingsPageListTile({
    Key? key,
    required this.basePageViewRect,
    required this.guestRect,
    required this.index,
    this.leading,
  }) : super(key: key) {
    //  Create [hostRect], a representation of [SettingsPageListTile],
    //  from [basePageViewRect].
    hostRect = basePageViewRect
        .inflateToHeight(height)
        .moveTopLeftTo(basePageViewRect.topLeft)
        .translate(0, height * index);

    //  Generate construction Rects.
    centralConstrRect = centralConstructionRect;
    lowerConstrRect = lowerConstructionRect;
    upperConstrRect = upperConstructionRect;

    //  Upload the radius of curvature.
    if (guestRect != null) r = guestRect!.shortestSide / 2;
  }

  /// The visible area on screen that contains [SettingsPageContents].
  final Rect basePageViewRect;

  /// The Rect on screen which [SettingsPageListTile] will avoid when scrolling.
  final Rect? guestRect;

  /// Unique identifier for [SettingsPageListTile].
  final int index;

  /// A widget to display before the title.
  final Widget? leading;

  final double height = 75.0;

  /// The radius associated with the sliding motion of [SettingsPageListTile].
  double r = 0.0;

  /// A construction Rect centred on [guestRect].
  Rect? centralConstrRect;

  /// A Rect variable representing [SettingsPageListTile] on screen.
  late Rect hostRect;

  /// A construction Rect that is the same width as [guestRect] and which
  /// overlaps with [guestRect.bottomLeft] and [guestRect.bottomRight].
  Rect? lowerConstrRect;

  /// A construction Rect that is the same width as [guestRect] and which
  /// overlaps with [guestRect.topLeft] and [guestRect.topRight].
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
      double rectHeight = 1.125 * guestRect!.shortestSide;

      //  Inflate [guestRect] to a new height centered on the original, then
      //  move it so that its top left corner is coincident with
      //  [guestRect.bottomLeft], finally translate it upwards by
      //  [guestRect!.shortestSide].
      return guestRect!
          .inflateToHeight(rectHeight)
          .moveTopLeftTo(guestRect!.bottomLeft)
          .translate(0.0, -guestRect!.shortestSide / 2);
    } else
      return null;
  }

  /// Getter for [upperConstrRect].
  Rect? get upperConstructionRect {
    if (guestRect != null) {
      double rectHeight = 1.125 * guestRect!.shortestSide;

      //  Inflate [guestRect] to a new height centered on the original, then
      //  move it so that its bottom left corner is coincident with
      //  [guestRect.topLeft], finally translate it downwards by
      //  [guestRect!.shortestSide].
      return guestRect!
          .inflateToHeight(rectHeight)
          .moveBottomLeftTo(guestRect!.topLeft)
          .translate(0.0, guestRect!.shortestSide / 2);
    } else
      return null;
  }

  /// [getDeltaX] calculates the horizontal displacement to apply to
  /// [SettingsPageListTile] as it passes [guestRect].
  double getDeltaX(double scrollPosition) {
    double? deltaX;
    Rect rect = hostRect.shift(Offset(0.0, -scrollPosition));

    //  Determine which method to use for calculating [deltaX].
    if (guestRect != null) {
      if (lowerConstrRect!.boundsContain(rect.topLeft) ||
          lowerConstrRect!.boundsContain(rect.topRight)) {
        //  Top of [rect] is overlapped by [lowerConstrRect].
        //  Calculate y relative to [lowerConstrRect!.bottom]; the positive
        //  y-axis points vertically upwards in this function.
        double y = lowerConstrRect!.bottom - rect.top;

        //  Calculate deltaX.
        deltaX = getDeltaXFromY(lowerConstrRect!, y);
      } else if (upperConstrRect!.boundsContain(rect.bottomLeft) ||
          upperConstrRect!.boundsContain(rect.bottomRight)) {
        //  Bottom of [rect] is overlapped by [upperConstrRect].
        //  Calculate y relative to [upperConstrRect!.bottom]; the positive
        //  y-axis points vertically upwards in this function.
        double y = upperConstrRect!.bottom - rect.bottom;

        //  Calculate deltaX and subtract it from guestRect!.width because
        //  it is the opposite to the above procedure.
        deltaX = getDeltaXFromY(upperConstrRect!, y);
        deltaX = guestRect!.width - deltaX;
      } else if (centralConstrRect!.overlaps(rect)) {
        //  [centralConstrRect] overlaps with [rect].
        deltaX = guestRect!.width;
      }
    }

    //  Return [deltaX] or zero, but not null.
    return deltaX ?? 0.0;
  }

  /// [getDeltaXFromY] calculates the value to subtract from the width
  /// of [SettingsPageListTile] in order to accommodate [ButtonArray].
  ///
  /// The maximum value of [deltaX] corresponds to when [SettingsPageListTile]
  /// is alongside [ButtonArray].
  ///
  /// [deltaX] is a smooth function of [y], the vertical displacement between
  /// the bottom edge of [lowerConstrRect] and the top edge of
  /// [SettingsPageListTile]. For the purpose of calculating deltaX, the origin
  /// is taken to be the bottom left corner of [lowerConstrRect].
  ///
  /// The bottom corner follows a path that is made up of a curved, circular
  /// section, a line segment and a curved section. The line passes through
  /// (a,b), the coordinates of the centre point of [lowerConstrRect],
  /// and is tangent to the curve at (xCrit, yCrit).
  double getDeltaXFromY(Rect rect, double y) {
    //  ([a], [b]) are the coordinates of the point of symmetry, taken to
    //  be the centre of [rect].
    //
    //  Relative to the bottom left corner of [rect], [a] and [b] have
    //  the values as follows.
    double a = rect.width / 2.0;
    double b = rect.height / 2.0;

    //  In order to avoid generating complex numbers aa + bb - 2ra > 0.
    assert(
        a * a + b * b - 2 * r * a >= 0,
        'SettingsPageListTile, getDeltaXFromY: '
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

    //  Calculate deltaX.
    double? deltaX;
    if (y <= yCrit) {
      //  The bottom left corner of [lowerConstrRect] is the origin
      //  of the bounding box.
      //
      //  (xCrit,yCrit) is the point where the curve joins to the line segment.
      //  (r,0) is the centre of the circle. To get deltaX invert
      //      (x - r)^2 + (y - 0)^2 = r^2,
      //  taking the negative root.
      deltaX = r - math.sqrt(r * r - y * y);
    } else if (y <= 2 * b - yCrit) {
      //  The bottom left corner of [lowerConstrRect] is the origin
      //  of the bounding box.
      //
      //  By symmetry, the line segment joins (xCrit,yCrit) to
      //  (2a - xCrit,2b - yCrit). To get the equation for deltaX invert
      //      (x - xCrit) / (y - yCrit)
      //          = (2a - xCrit - xCrit) / (2b - yCrit - yCrit),
      //  which just equates gradients.
      deltaX = xCrit + (y - yCrit) * (a - xCrit) / (b - yCrit);
    } else if (y <= 2 * b) {
      //  The bottom left corner of [lowerConstrRect] is the origin
      //  of the bounding box.
      //
      //  (2a - xCrit,2b - yCrit is the point where the curve joins to the
      //  line segment. (2a - r,2b) is the centre of the circle. To get
      //  deltaX invert
      //      (x - (2a - r))^2 + (y - 2b)^2 = r^2
      //  taking the positive root.
      deltaX = (2 * a - r) + math.sqrt(r * r - (y - 2 * b) * (y - 2 * b));
    } else {
      assert(
          false,
          'SettingsPageListTile, getDeltaXFromY: '
          'error, invalid y-value.');
    }
    return deltaX ?? 0.0;
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
        double deltaX = getDeltaX(value);
        double width = hostRect.width - deltaX;

        // Diagnostics...delete.
        if (index == 10) {
          print('basePageViewRect.width = ${basePageViewRect.width}');
          print('deltaX = ${deltaX}');
          print('width = ${width}');
          print('guestRect!.width = ${guestRect!.width}');
        }

        //  The topmost instance of Container, with the use of deltaX to
        //  define margin, implements the variable width settings panel.
        return BoxedContainer(
          margin: AppSettings.buttonAlignment.isLeft
              ? EdgeInsets.only(left: deltaX)
              : EdgeInsets.only(right: deltaX),
          height: height,
          padding: AppSettings.settingsPageListTilePadding,
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
                      borderRadius: BorderRadius.circular(AppSettings.settingsPageListTileRadius),
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
                          Colors.green[50]!.withOpacity(0.0),
                          Colors.green[50]!.withOpacity(1.0),
                          Colors.green[50]!.withOpacity(1.0),
                        ]
                      ),
                    ),
                  ),
                  // child: CustomPaint(
                  //   foregroundPainter: FadingEffect(),
                    // child: BoxedContainer(
                    //   borderRadius: AppSettings.settingsPageListTileRadius,
                    //   width: 2 * AppSettings.settingsPageListTileIconSize,
                    //   height: height/2 +20,
                    // ),
                  // ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class _SettingsPageListTileClipper extends CustomClipper<Path> {
//   _SettingsPageListTileClipper({
//     Listenable? reclip,
//     required this.width,
//     required this.index,
//   }) : super(reclip: reclip);
//
//   final double width;
//   final int index;
//
//   @override
//   Path getClip(Size size) {
//     print('index = $index');
//     if (index == 10) {
//       print('_SettingsPageListTileClipper width = $width');
//     }
//     Rect rect = Offset.zero & Size(width, size.height);
//
//     Path path = Path();
//     return path..addRect(rect);
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => true;
// }



//  https://stackoverflow.com/questions/62782165/how-to-create-this-linear-fading-opacity-effect-in-flutter-for-android
class FadingEffect extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height));
    LinearGradient lg = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: [
          0.0,
          0.8,
          1.0,
        ],
        colors: [
          //create 2 white colors, one transparent
          Colors.green[500]!.withOpacity(0.0),
          Colors.green[500]!.withOpacity(1.0),
          Colors.green[500]!.withOpacity(1.0),
        ]);
    Paint paint = Paint()..shader = lg.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(FadingEffect linePainter) => false;
}