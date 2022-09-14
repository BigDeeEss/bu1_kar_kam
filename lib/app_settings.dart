//  Import flutter packages.
import 'package:flutter/material.dart';

/// Class container for all app settings.
class AppSettings {
  /// [appBarHeightScaleFactor] defines a simple scale factor to apply to
  /// appBar when calculating bottomNavigationBar height in BasePage class.
  static double appBarHeightScaleFactor = 1.0;

  /// [buttonAlignment] defines the position of the anchor that determines
  /// button placement in ButtonArray class.
  // static Alignment buttonAlignment = Alignment.bottomLeft;
  // static Alignment buttonAlignment = Alignment.bottomRight;
  static Alignment buttonAlignment = Alignment.topLeft;
  // static Alignment buttonAlignment = Alignment.topRight;

  /// [buttonAxis] sets the button axis type in ButtonArray.
  static Axis buttonAxis = Axis.horizontal;
  // static Axis buttonAxis = Axis.vertical;

  /// [buttonPadding] defines the padding surrounding each button.
  static EdgeInsetsDirectional buttonPadding =
      EdgeInsetsDirectional.all(buttonPaddingMainAxis);

  /// [buttonPaddingMainAxis] defines the main axis padding between buttons.
  static double buttonPaddingMainAxis = 15.0;

  /// [buttonPaddingMainAxisAlt] defines an alternative main axis padding
  /// between buttons.
  static double buttonPaddingMainAxisAlt = 12.5;

  /// [buttonRadius] defines the button radius in Button class.
  static double buttonRadius = 28.0;

  /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
  ///
  /// Used for debugging widget screen location.
  static bool drawLayoutBounds = true;

  /// [pageTransitionTime] defines the page transition time in milliseconds.
  static int pageTransitionTime = 750;

  /// [settingsPageListTileIconSize] defines the icon radius.
  static double settingsPageListTileIconSize = 25.0;

  /// [settingsPageListTilePadding] defines the padding between tiles.
  static double settingsPageListTilePadding = 2.0;

  /// [settingsPageListTileRadius] defines the tile corner radius.
  static double settingsPageListTileRadius = 15.0;
}
