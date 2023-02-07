//  Import flutter packages.

import 'package:flutter/material.dart';

class SettingsData {
  /// [buttonAxis] sets the button axis type in ButtonArray.
  Axis buttonAxis = Axis.horizontal;

  /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
  ///
  /// Used for debugging widget screen location.
  bool drawLayoutBounds = true;

  /// [settingsPageListTileFadeEffect] switches in/out the Text fade effect.
  bool settingsPageListTileFadeEffect = true;

  late Map<String, Function> map;

  void toggleButtonAxis() => buttonAxis = flipAxis(buttonAxis);

  void toggleDrawLayoutBounds() => drawLayoutBounds = !drawLayoutBounds;

  void toggleSettingsPageListTileFadeEffect() =>
      settingsPageListTileFadeEffect = !settingsPageListTileFadeEffect;

  void init() {
    map = {
      'buttonAxis': () => toggleButtonAxis(),
      'drawLayoutBounds': () => toggleDrawLayoutBounds(),
      'settingsPageListTileFadeEffect': () =>
          toggleSettingsPageListTileFadeEffect(),
    };
  }
}
