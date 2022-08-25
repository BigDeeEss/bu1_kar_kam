//  Import flutter packages.
import 'package:flutter/material.dart';

/// Class for ease of import of app settings.
class AppSettings {
  /// [appBarHeightScaleFactor] defines a simple scale factor to apply to
  /// appBar when calculating bottomNavigationBar height in BasePage class.
  static double appBarHeightScaleFactor = 1.0;

  /// [buttonAlignment] defines the anchor point for button placement
  /// in ButtonArray class.
  // static Alignment buttonAlignment = Alignment.bottomLeft;
  static Alignment buttonAlignment = Alignment.bottomRight;
  // static Alignment buttonAlignment = Alignment.topLeft;
  // static Alignment buttonAlignment = Alignment.topRight;

  /// [buttonAxis] sets the button axis in ButtonArray.
  // static Axis buttonAxis = Axis.horizontal;
  static Axis buttonAxis = Axis.vertical;

  /// [buttonPadding] defines the padding surrounding each button.
  static EdgeInsetsDirectional buttonPadding =
      EdgeInsetsDirectional.all(buttonPaddingMainAxis);

  /// [buttonPaddingMainAxis] defines the main axis padding between buttons.
  static double buttonPaddingMainAxis = 15.0;

  /// [buttonPaddingMainAxisExtra] defines extra padding in main axis direction.
  static double buttonPaddingMainAxisExtra = 12.5;

  /// [buttonSize] defines the button radius in Button class.
  static double buttonRadiusInner = 28.0;

  /// [buttonSize] defines the button radius plus padding in Button class.
  static double buttonRadiusOuter = buttonRadiusInner + buttonPaddingMainAxis;

  /// [drawLayoutBounds] triggers whether layout bounds are draw or not.
  /// Used for debugging widget screen location.
  static bool drawLayoutBounds = true;

  /// [pageTransitionTime] defines the time in milliseconds allowed
  /// for the transitioning the page.
  static int pageTransitionTime = 750;

  /// [settingsPageListTileIconSize] defines the radius used in construction
  /// of SettingsPageListTile.
  static double settingsPageListTileIconSize = 25;

  /// [settingsPageListTileRadius] defines the radius used in construction
  /// of SettingsPageListTile.
  static double settingsPageListTileRadius = 0;

  /// [settingsPageListTilePadding] defines the padding used in construction
  /// of settingsPageListTile.
  static double settingsPageListTilePadding = 0.0;
}
