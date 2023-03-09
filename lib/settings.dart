//  Import flutter packages.
import 'package:flutter/material.dart';

class Settings {
  /// [appBarHeightScaleFactor] defines a simple scale factor to apply to
  /// appBar when calculating bottomNavigationBar height in BasePage class.
  double appBarHeightScaleFactor = 1.0;

  /// [buttonAlignment] defines the position of the anchor that determines
  /// button placement in the ButtonArray class.
  // static Alignment buttonAlignment = Alignment.bottomLeft;
  // static Alignment buttonAlignment = Alignment.bottomRight;
  Alignment buttonAlignment = Alignment.topLeft;

  /// Sets the button axis in ButtonArray.
  Axis buttonAxis = Axis.horizontal;

  /// [buttonPaddingMainAxis] defines the main axis padding between buttons.
  double buttonPaddingMainAxis = 15.0;

  /// [buttonRadius] defines the button radius in Button class.
  double buttonRadius = 28.0;

  /// Determines whether BoxedContainer draws bounding boxes or not.
  bool drawLayoutBounds = true;

  /// Determines whether the fade effect in SettingsPageListTile
  /// is active or not.
  bool settingsPageListTileFadeEffect = true;

  /// Toggles [buttonAxis].
  void toggleButtonAxis() => buttonAxis = flipAxis(buttonAxis);

  /// Toggles [drawLayoutBounds].
  void toggleDrawLayoutBounds() => drawLayoutBounds = !drawLayoutBounds;

  /// Toggles [settingsPageListTileFadeEffect].
  void toggleSettingsPageListTileFadeEffect() =>
      settingsPageListTileFadeEffect = !settingsPageListTileFadeEffect;

  void printThis() {
    print('Settings, buttonAxis = ${buttonAxis}');
    print('Settings, drawLayoutBounds = ${drawLayoutBounds}');
    print(
        'Settings, settingsPageListTileFadeEffect = ${settingsPageListTileFadeEffect}');
  }

  /// Updates this using string to determine which field is set to newValue.
  Settings change({
    required String identifier,
    var newValue,
  }) {
    // Define a map that converts string to a class method.
    // ToDo: add functionality for other fields in Settings class.
    Map<String, Function> map = {
      'appBarHeightScaleFactor': (double newValue) =>
          appBarHeightScaleFactor = newValue,
      'buttonAxis': (newValue) => toggleButtonAxis(),
      'drawLayoutBounds': (newValue) => toggleDrawLayoutBounds(),
      'settingsPageListTileFadeEffect': (newValue) =>
          toggleSettingsPageListTileFadeEffect(),
    };

    // print('SettingsDataSeven, change...$drawLayoutBounds');

    //  Call the function determined from map.
    map[identifier]?.call(newValue);

    // print('SettingsDataSeven, change...$drawLayoutBounds');

    //  Return this instance of SettingsDataSeven.
    return this;
  }
}
