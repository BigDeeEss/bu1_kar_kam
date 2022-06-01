//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/lib/rect_extension.dart';

class SettingsPageListTileFromContainer extends StatelessWidget {
  SettingsPageListTileFromContainer({Key? key}) : super(key: key);

  late Rect buttonArrayRect;

  double getDeltaX(Rect? guestRect, Rect hostRect) {
    double deltaX= 0.0;
    if (guestRect != null) {
      late double y;
      Rect lowerConstructionRect = getLowerConstructionRect(guestRect);
      Rect upperConstructionRect = getUpperConstructionRect(guestRect);
      Rect centralConstructionRect = getCentralConstructionRect(guestRect);
      
      if (upperConstructionRect.boundsContain(hostRect.bottomLeft) ||
          upperConstructionRect.boundsContain(hostRect.bottomRight)) {
        //  Bottom of [guestRect] lies within [upperConstructionRect].
        //  Transform guestRect.bottom so that it represents a displacement in the
        //  upwards direction relative to upperConstructionRect!.bottom.
        y = upperConstructionRect.bottom - hostRect.bottom;
        deltaX = getDeltaXFromUpperConstructionRect(upperConstructionRect, y);
      } else if (lowerConstructionRect.boundsContain(hostRect.topLeft) ||
          lowerConstructionRect.boundsContain(hostRect.topRight)) {
        //  Top of [guestRect] lies within [lowerConstructionRect]
        //  Transform guestRect.top so that it represents a displacement in the
        //  upwards direction relative to lowerConstructionRect!.bottom.
        y = lowerConstructionRect.bottom - hostRect.top;
        deltaX = getDeltaXFromLowerConstructionRect(lowerConstructionRect, y);
      } else if (centralConstructionRect.overlaps(hostRect)) {
        //  [guestRect] overlaps with [upperConstructionRect].
        deltaX = guestRect.width;
      }
    }
    return deltaX;
  }

  /// Getter for [centralConstructionRect].
  Rect getCentralConstructionRect(Rect localButtonArrayRect){
    //  Inflate [rect] to a new height centered on the original [rect].
    Rect rect = localButtonArrayRect;
    return rect
        .inflateToHeight(math.max(0.0, rect.height - rect.shortestSide));
  }

  /// [getDeltaXFromUpperLocalConstructionRect] calculates the amount,
  /// [deltaX], to increase the width of [SettingsPageListTile] from its
  /// minimum value in order to fill the screen. The minimum value
  /// corresponds to when [SettingsPageListTile] is alongside [ButtonArray].
  ///
  /// [deltaX] = 0 corresponds to the position where [SettingsPageListTile]
  /// is alongside or passing [ButtonArray]. From the side of the screen,
  /// this means maximum deflection.
  ///
  /// For the purpose of calculating deltaX, the origin is taken to be
  /// the bottom left corner of [upperLocalConstructionRect].
  ///
  /// The value of [deltaX] is the horizontal adjustment to applied to the
  /// width of [SettingsPageListTile]. In other words the bottom corner
  /// follows a path that is made up of a curved, circular section and a line
  /// segment. The line passes through (a,b) and is tangent to the curve
  /// at (xCrit, yCrit).
  double getDeltaXFromUpperConstructionRect(Rect rect, double y) {
    //  The method for determining [deltaX] is follows the method for
    //  obtaining [getDeltaXFromLowerLocalConstructionRect].
    //  [a] is the x-coordinate of the point of symmetry, taken to
    //  be the centre of [upperLocalConstructionRect], relative to
    //  upperLocalConstructionRect!.bottom.
    double a = rect.width / 2.0;
    return 2 * a - getDeltaXFromLowerConstructionRect(rect, y);
  }

  /// [getDeltaXFromLowerLocalConstructionRect] calculates the amount,
  /// [deltaX], to decrease the width of [SettingsPageListTile] from its
  /// maximum value in order to accommodate [ButtonArray].
  ///
  /// The maximum value of [deltaX] corresponds to when [SettingsPageListTile]
  /// is alongside [ButtonArray] when it has the minimum value, [deltaX] = 0.
  ///
  /// [deltaX] is a smooth function of [y], the vertical displacement between
  /// the bottom edge of [lowerLocalConstructionRect] and the top edge of
  /// [SettingsPageListTile]. For the purpose of calculating deltaX, the origin
  /// is taken to be the bottom left corner of [lowerLocalConstructionRect].
  ///
  /// The bottom corner follows a path that is made up of a curved, circular
  /// section and a line segment. The line passes through (a,b), the coordinates
  /// of the centre point of [lowerLocalConstructionRect], and is tangent to
  /// the curve at (xCrit, yCrit).
  double getDeltaXFromLowerConstructionRect(Rect rect, double y) {
    //  [r] is the radius of the curved path section.
    double r = rect.shortestSide / 2.0;

    //  ([a], [b]) are the coordinates of the point of symmetry, taken to
    //  be the centre of [lowerLocalConstructionRect]. Relative to the
    //  bottom left corner of [lowerLocalConstructionRect], [a] and [b] have
    //  the values as follows.
    double a = rect.width / 2.0;
    double b = rect.height / 2.0;

    //  In order to avoid generating complex numbers aa + bb - 2ra must be
    //  greater than zero.
    assert(a * a + b * b - 2 * r * a >= 0,
    'SettingsPageListTileBorder, getDeltaXFromLowerLocalConstructionRect: '
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
    if (y < yCrit) {
      //  The bottom left corner of [lowerLocalConstructionRect] is the origin
      //  of the bounding box.
      //
      //  (xCrit,yCrit) is the point where the curve joins to the line segment.
      //  (r,0) is the centre of the circle. To get deltaX invert
      //      (x - r)^2 + (y - 0)^2 = r^2,
      //  taking the negative root.
      deltaX = r - math.sqrt(r * r - y * y);
    } else if (y < 2 * b - yCrit) {
      //  The bottom left corner of [lowerLocalConstructionRect] is the origin
      //  of the bounding box.
      //
      //  By symmetry, the line segment joins (xCrit,yCrit) to
      //  (2a - xCrit,2b - yCrit). To get the equation for deltaX invert
      //      (x - xCrit) / (y - yCrit)
      //          = (2a - xCrit - xCrit) / (2b - yCrit - yCrit),
      //  which just equates gradients.
      deltaX = xCrit + (y - yCrit) * (a - xCrit) / (b - yCrit);
    } else if (y < 2 * b) {
      //  The bottom left corner of [lowerLocalConstructionRect] is the origin
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
      'SettingsPageListTileBorder, getDeltaXFromLowerLocalConstructionRect: '
          'error, invalid y-value.');
    }
    //
    return deltaX;
  }

  /// [getLocalButtonArrayRect] converts [buttonArrayRect] from
  /// global (screen) coordinates to a coordinate system local
  /// to [SettingsPageListTile].
  Rect? getLocalButtonArrayRect(Rect buttonArrayRect, BuildContext context) {
    //  Get [renderBox] associated with [SettingsPageListTile].
    //
    //  ([renderBox] is used to generate [localGuestRect] from [guestRect].)
    //
    //  Note: the output of context.findRenderObject() can be null depending on
    //  where relative to the screen [SettingsPageListTile] is created.
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      //  Get the global offset associated with the top left corner of
      //  [SettingsPageListTile] relative to the top left screen corner.
      Offset offset = renderBox.globalToLocal(Offset.zero);

      //  Transform [guestRect] from the global coordinate system to one that is
      //  local to [renderBox] or the current local instance of ListTile.
      return buttonArrayRect.shift(offset);
    } else return null;
  }

  /// [getLowerConstructionRect] generates a construction rect below the
  /// centre of [localButtonArrayRect] to be used for calculating [deltaX].
  Rect getLowerConstructionRect(Rect localButtonArrayRect) {
    //  Inflate [rect] to a new height centered on the original Rect.
    Rect rect = localButtonArrayRect
        .inflateToHeight(1.0 * localButtonArrayRect.shortestSide);

    //  Calculate shift factor and apply to rect.
    double dy = localButtonArrayRect.height / 2.0 +
        rect.height / 2.0 -
        rect.shortestSide / 2.0;
    return rect.shift(Offset(0.0, dy));
  }

  /// Getter for [upperConstructionRect]
  Rect getUpperConstructionRect(Rect localButtonArrayRect) {
    //  Inflate [rect] to a new height centered on original Rect.
    Rect rect = localButtonArrayRect
        .inflateToHeight(1.0 * localButtonArrayRect.shortestSide);

    //  Calculate shift factor and apply to rect.
    double dy = localButtonArrayRect.height / 2.0 +
        rect.height / 2.0 -
        rect.shortestSide / 2.0;
    return rect.shift(Offset(0.0, -dy));
  }

  @override
  Widget build(BuildContext context) {
    //  Retrieve buttonArrayRect from DataNotifier further up the widget tree.
    buttonArrayRect =
        DataNotifier.of(context, ValueKey('buttonArrayRect')).data.value;

    //  Build [SettingsPageListTileFromContainer] each time
    //  [SettingsPageContents] is scrolled.
    return ValueListenableBuilder<double>(
      valueListenable:
          DataNotifier.of(context, ValueKey('scrollController')).data,
      builder: (BuildContext context, double value, __) {
        //  Default height and width for [SettingsPageListTile].
        double width = MediaQuery.of(context).size.width;
        double height = 40;
        Rect hostRect = Offset.zero & Size(width, 40);

        //  Convert [buttonArrayRect] from global to local coordinates.
        Rect? localButtonArrayRect =
            getLocalButtonArrayRect(buttonArrayRect, context);

        double deltaX = getDeltaX(localButtonArrayRect, hostRect);
        print('localButtonArrayRect = $localButtonArrayRect, deltaX = $deltaX');
        print(width - deltaX);

        return Container(
          //  Draw boundng box.
          decoration: BoxDecoration(
            border: AppSettings.drawLayoutBounds
                ? Border.all(width: 0.0, color: Colors.redAccent)
                : null,
          ),
          margin: EdgeInsets.only(left: deltaX),
          child: Container(
            // key: UniqueKey(),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            // width: width - deltaX,
            child: Center(
                child: Text('test..')
            ),
          ),
          // child: Material(
          //   key: UniqueKey(),
          //   child: SizedBox(
          //     key: UniqueKey(),
          //     // width: width - deltaX,
          //     // height: height,
          //     child: Container(
          //       // key: UniqueKey(),
          //       decoration: BoxDecoration(
          //         color: Colors.purple,
          //         borderRadius: BorderRadius.all(
          //           Radius.circular(12.0),
          //         ),
          //       ),
          //       // width: width - deltaX,
          //       width: 100000,
          //       height: height,
          //       child: Center(
          //           child: Text('test..')
          //       ),
          //     ),
          //   ),
          // ),
        );
        // return Material(
        //   key: UniqueKey(),
        //   child: SizedBox(
        //     // key: UniqueKey(),
        //     width: width - deltaX,
        //     height: width - deltaX,
        //     child: Container(
        //       // key: UniqueKey(),
        //       decoration: BoxDecoration(
        //         color: Colors.purple,
        //         borderRadius: BorderRadius.all(
        //           Radius.circular(12.0),
        //         ),
        //       ),
        //       width: width - deltaX,
        //       height: height,
        //       child: Center(
        //           child: Text('test..')
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }
}