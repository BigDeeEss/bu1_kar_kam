// Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/button_specs.dart';

/// Stores app settings.
class Settings {
  /// A scale factor which is applied to [appBarHeight] in order to calculate
  /// the [BottomAppBar] height in [BasePage] class.
  double appBarHeightScaleFactor = 1.0;

  /// The anchor location that determines button placement in [ButtonArray].
  // static Alignment buttonAlignment = Alignment.bottomLeft;
  // static Alignment buttonAlignment = Alignment.bottomRight;
  Alignment buttonAlignment = Alignment.topLeft;

  /// The button axis in [ButtonArray].
  Axis buttonAxis = Axis.horizontal;

  /// Defines the padding surrounding each button.
  EdgeInsetsDirectional get buttonPadding =>
      EdgeInsetsDirectional.all(buttonPaddingMainAxis);

  /// Main axis padding between buttons in [ButtonArray].
  double buttonPaddingMainAxis = 15.0;

  /// An alternative main axis padding between buttons in [ButtonArray].
  double buttonPaddingMainAxisAlt = 12.5;

  /// Button radius in [Button] class.
  double buttonRadius = 28.0;

  /// Specs for each button in [ButtonArray].
  List<ButtonSpec> buttonSpecList = [
    settingsButton,
    filesButton,
    homeButton,
  ];

  /// Whether [BoxedContainer] draws bounding boxes or not.
  bool drawLayoutBounds = true;

  /// Whether fade effect in SettingsPageListTile is active or not.
  bool settingsPageListTileFadeEffect = true;

  /// Defines the icon radius in Button.
  double settingsPageListTileIconSize = 25.0;

  /// Toggles [buttonAxis].
  void toggleButtonAxis() => buttonAxis = flipAxis(buttonAxis);

  /// Toggles [drawLayoutBounds].
  void toggleDrawLayoutBounds() => drawLayoutBounds = !drawLayoutBounds;

  /// Toggles [settingsPageListTileFadeEffect].
  void toggleSettingsPageListTileFadeEffect() =>
      settingsPageListTileFadeEffect = !settingsPageListTileFadeEffect;

  // For diagnostics.
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
    // Define a map that converts [string] to a class method.
    // ToDo: add functionality for other fields in Settings class.
    Map<String, Function> map = {
      'appBarHeightScaleFactor': (double newValue) =>
          appBarHeightScaleFactor = newValue,
      'buttonAxis': (newValue) => toggleButtonAxis(),
      'drawLayoutBounds': (newValue) => toggleDrawLayoutBounds(),
      'settingsPageListTileFadeEffect': (newValue) =>
          toggleSettingsPageListTileFadeEffect(),
    };

    // Call the function determined from [map] and update relevant field.
    map[identifier]?.call(newValue);

    // Return this instance of [Settings].
    return this;
  }
}
