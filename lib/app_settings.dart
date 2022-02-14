//  Import flutter packages.
import 'package:flutter/painting.dart';

/// Class for ease of import of app settings.
class AppSettings {
  /// [appBarHeightScaleFactor] defines a simple scale factor to apply to
  /// appBar when calculating bottomNavigationBar height in BasePage class.
  static double appBarHeightScaleFactor = 1.0;
  //
  /// [buttonAlignment] defines the anchor point for button placement
  /// in ButtonArray class.
  // static Alignment buttonAlignment = Alignment.bottomLeft;
  static Alignment buttonAlignment = Alignment.bottomRight;
  // static Alignment buttonAlignment = Alignment.topLeft;
  // static Alignment buttonAlignment = Alignment.topRight;

  /// [buttonAxis] sets the button axis in ButtonArray.
  // static Axis buttonAxis = Axis.horizontal;
  static Axis buttonAxis = Axis.vertical;

  // /// [buttonAnimationTime] defines the time in milliseconds allowed
  // /// for the button animation in BasePage.
  // static int buttonAnimationTime = 1500;

  /// [buttonPaddingDown] defines the padding for downward direction
  /// button positioning in Button class.
  static EdgeInsetsDirectional buttonPaddingDown =
      EdgeInsetsDirectional.fromSTEB(
    buttonPaddingCrossAxis,
    buttonPaddingMainAxis,
    buttonPaddingCrossAxis,
    buttonPaddingMainAxisExtra,
  );

  /// [buttonPaddingCrossAxis] defines the cross axis padding between buttons.
  static double buttonPaddingCrossAxis = 15.0;

  /// [buttonPaddingMainAxis] defines the main axis padding between buttons.
  static double buttonPaddingMainAxis = 15.0;

  /// [buttonPaddingMainAxisExtra] defines extra padding in main axis direction.
  static double buttonPaddingMainAxisExtra = 10.0;

  /// [buttonPaddingUp] defines the padding for downward direction
  /// button positioning in Button class.
  static EdgeInsetsDirectional buttonPaddingUp =
      EdgeInsetsDirectional.fromSTEB(
    buttonPaddingCrossAxis,
    buttonPaddingMainAxisExtra,
    buttonPaddingCrossAxis,
    buttonPaddingMainAxis,
  );

  /// [buttonSize] defines the button size in Button class.
  static double buttonSize = 56.0;

  /// [drawLayoutBounds] triggers whether layout bounds are draw or not.
  /// Used for debugging widget screen location.
  static bool drawLayoutBounds = true;

  /// [pageTransitionTime] defines the time in milliseconds allowed
  /// for the transitioning the page.
  static int pageTransitionTime = 750;
}
