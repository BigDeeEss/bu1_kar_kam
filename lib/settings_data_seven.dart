//  Import flutter packages.
import 'package:flutter/material.dart';

class SettingsDataSeven {
  /// Sets the button axis in ButtonArray.
  Axis buttonAxis = Axis.horizontal;

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
    print('Settings, settingsPageListTileFadeEffect = ${settingsPageListTileFadeEffect}');
  }

  /// Updates this using string to determine which field is set to newValue.
  SettingsDataSeven change({
    required String identifier,
    var newValue,
  }) {
    //  Define a map that converts string to a class method.
    Map<String, Function> map = {
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