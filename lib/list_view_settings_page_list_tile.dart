//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/lib/rect_extension.dart';

class ListViewSettingsPageListTile extends StatelessWidget {
  ListViewSettingsPageListTile({Key? key}) : super(key: key);

  late Rect buttonArrayRect;

  /// [getButtonArrayRect] converts [buttonArrayRect] from
  /// global (screen) coordinates to a coordinate system that is local
  /// to [ListViewSettingsPageListTile].
  Rect? getButtonArrayRect(Rect buttonArrayRect, BuildContext context) {
    //  Get [renderBox] associated with [SettingsPageListTile].
    //
    //  ([renderBox] is used to generate [GuestRect] from [guestRect].)
    //
    //  Note: the output of context.findRenderObject() can be null depending on
    //  where relative to the screen [SettingsPageListTile] is created.
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      //  Get the global offset associated with the top left corner of
      //  [SettingsPageListTile] relative to the top left screen corner.
      Offset offset = renderBox.globalToLocal(Offset.zero);

      //  Transform [guestRect] from the global to local coordinates.
      return buttonArrayRect.shift(offset);
    } else return null;
  }

  /// [getCentralConstructionRect] inflates [localButtonArrayRect] to a
  /// new height centered on the original.
  Rect getCentralConstructionRect(Rect localButtonArrayRect){
    Rect rect = localButtonArrayRect;
    return rect
        .inflateToHeight(math.max(0.0, rect.height - rect.shortestSide));
  }

  /// [getDeltaX] calculates the displacement to apply to
  /// [ListViewSettingsPageListTile] as it passes [buttonArrayRect].
  double getDeltaX(Rect? guestRect, Rect hostRect) {
    //  Default value is no displacement.
    double deltaX = 0.0;
    if (guestRect != null) {
      late double y;
      Rect lowerConstructionRect = getLowerConstructionRect(guestRect);
      Rect upperConstructionRect = getUpperConstructionRect(guestRect);
      Rect centralConstructionRect = getCentralConstructionRect(guestRect);

      //  Determine which method to use for calculating [deltaX].
      if (upperConstructionRect.boundsContain(hostRect.bottomLeft) ||
          upperConstructionRect.boundsContain(hostRect.bottomRight)) {
        //  Bottom of [guestRect] lies within [upperConstructionRect].
        //  Transform guestRect.bottom so that its coordinates represent
        //  a displacement in the upwards direction relative to
        //  upperConstructionRect.bottom.
        y = upperConstructionRect.bottom - hostRect.bottom;
        deltaX = getDeltaXFromUpperConstructionRect(upperConstructionRect, y);
      } else if (lowerConstructionRect.boundsContain(hostRect.topLeft) ||
          lowerConstructionRect.boundsContain(hostRect.topRight)) {
        //  Top of [guestRect] lies within [lowerConstructionRect].
        //  Transform guestRect.top so that its coordinates represent
        //  a displacement in the upwards direction relative to
        //  lowerConstructionRect.bottom.
        y = lowerConstructionRect.bottom - hostRect.top;
        deltaX = getDeltaXFromLowerConstructionRect(lowerConstructionRect, y);
      } else if (centralConstructionRect.overlaps(hostRect)) {
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
  double getDeltaXFromLowerConstructionRect(Rect rect, double y) {
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
    if (y < yCrit) {
      //  The bottom left corner of [lowerConstructionRect] is the origin
      //  of the bounding box.
      //
      //  (xCrit,yCrit) is the point where the curve joins to the line segment.
      //  (r,0) is the centre of the circle. To get deltaX invert
      //      (x - r)^2 + (y - 0)^2 = r^2,
      //  taking the negative root.
      deltaX = r - math.sqrt(r * r - y * y);
    } else if (y < 2 * b - yCrit) {
      //  The bottom left corner of [lowerConstructionRect] is the origin
      //  of the bounding box.
      //
      //  By symmetry, the line segment joins (xCrit,yCrit) to
      //  (2a - xCrit,2b - yCrit). To get the equation for deltaX invert
      //      (x - xCrit) / (y - yCrit)
      //          = (2a - xCrit - xCrit) / (2b - yCrit - yCrit),
      //  which just equates gradients.
      deltaX = xCrit + (y - yCrit) * (a - xCrit) / (b - yCrit);
    } else if (y < 2 * b) {
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

  /// [getDeltaXFromUpperConstructionRect] calculates the amount,
  //   /// [deltaX], to decrease the width of [SettingsPageListTile] from its
  //   /// maximum value in order to accommodate [ButtonArray].
  ///
  /// The maximum value of [deltaX] corresponds to when [ListViewSettingsPageListTile]
  /// is alongside [ButtonArray].
  ///
  /// [deltaX] is a smooth function of [y], the vertical displacement between
  /// the top edge of [upperConstructionRect] and the bottom edge of
  /// [ListViewSettingsPageListTile]. For the purpose of calculating deltaX, the origin
  /// is taken to be the top left corner of [upperConstructionRect].
  ///
  /// The bottom corner follows a path that is made up of a curved, circular
  /// section, a line segment and a curved section. The line passes through
  /// (a,b), the coordinates of the centre point of [upperConstructionRect],
  /// and is tangent to the curve at (xCrit, yCrit).
  double getDeltaXFromUpperConstructionRect(Rect rect, double y) {
    //  The method for determining [deltaX] is follows the method for
    //  obtaining [getDeltaXFromLowerConstructionRect].
    //
    //  [a] is the x-coordinate of the point of symmetry, taken to
    //  be the centre of [upperConstructionRect], relative to
    //  upperConstructionRect!.bottom.
    double a = rect.width / 2.0;
    return 2 * a - getDeltaXFromLowerConstructionRect(rect, y);
  }

  /// [getLowerConstructionRect] generates a construction rect below the
  /// centre of [ButtonArrayRect] to be used for calculating [deltaX].
  Rect getLowerConstructionRect(Rect ButtonArrayRect) {
    //  Inflate [rect] to a new height centered on the original Rect.
    Rect rect = ButtonArrayRect
        .inflateToHeight(1.0 * ButtonArrayRect.shortestSide);

    //  Calculate shift factor and apply to rect.
    double dy = ButtonArrayRect.height / 2.0 +
        rect.height / 2.0 -
        rect.shortestSide / 2.0;
    return rect.shift(Offset(0.0, dy));
  }

  /// [getUpperConstructionRect] generates a construction rect above the
  /// centre of [ButtonArrayRect] to be used for calculating [deltaX].
  Rect getUpperConstructionRect(Rect ButtonArrayRect) {
    //  Inflate [rect] to a new height centered on original Rect.
    Rect rect = ButtonArrayRect
        .inflateToHeight(1.0 * ButtonArrayRect.shortestSide);

    //  Calculate shift factor and apply to rect.
    double dy = ButtonArrayRect.height / 2.0 +
        rect.height / 2.0 -
        rect.shortestSide / 2.0;
    return rect.shift(Offset(0.0, -dy));
  }

  // For testing only.
  final Widget alignedContents = Align(
    alignment: Alignment.centerLeft,
    child: Text('test..'),
  );

  @override
  Widget build(BuildContext context) {
    //  Retrieve buttonArrayRect from DataNotifier further up the widget tree.
    buttonArrayRect =
        DataNotifier.of(context, ValueKey('buttonArrayRect')).data.value;

    //  Default height and width for [SettingsPageListTile].
    double width = MediaQuery.of(context).size.width;
    double height = 75;
    Rect hostRect = Offset.zero & Size(width, height);

    //  Build [SettingsPageListTileFromContainer] each time
    //  [SettingsPageContents] is scrolled.
    return ValueListenableBuilder<double>(
      valueListenable:
          DataNotifier.of(context, ValueKey('scrollController')).data,
      builder: (BuildContext context, double value, __) {
        //  Convert [buttonArrayRect] from global to local coordinates.
        Rect? localButtonArrayRect =
            getButtonArrayRect(buttonArrayRect, context);

        double deltaX = getDeltaX(localButtonArrayRect, hostRect);

        return Container(
          key: UniqueKey(),
          //  Draw bounding box around [SettingsPageListTile].
          decoration: BoxDecoration(
            border: AppSettings.drawLayoutBounds
                ? Border.all(width: 0.0, color: Colors.redAccent)
                : null,
          ),
          margin: EdgeInsets.only(left: deltaX),
          height: height,
          child: Container(
            key: UniqueKey(),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.5),
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: alignedContents,
          ),
        );
      },
    );
  }
}