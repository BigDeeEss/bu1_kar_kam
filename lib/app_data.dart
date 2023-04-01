// Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/button_array.dart';
import 'package:kar_kam/button_specs.dart';
import 'package:kar_kam/lib/rect_extension.dart';

/// Stores app data.
class AppData extends ChangeNotifier{
  /// A scale factor which is applied to [appBarHeight] in order to calculate
  /// the [BottomAppBar] height in [BasePage] class.
  double appBarHeightScaleFactor = 1.0;

  /// The Rect that represents the available screen dimensions.
  ///
  /// Initially Rect.zero, it is updated on first build.
  Rect basePageViewRect = Rect.zero;

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

  /// The Rect that represents the layout bounds for [ButtonArray].
  ///
  /// Initially Rect.zero, it is updated on first build.
  Rect buttonArrayRect = Rect.zero;

  Rect updateButtonArrayRect() {
    double dim = 2 * (buttonRadius + buttonPaddingMainAxisAlt);
    double shortLength = 2.0 * (buttonRadius + buttonPaddingMainAxis);
    double longLength = (buttonSpecList.length - 1) * dim + shortLength;

    // Generate Rect of the correct size at screen top left.
    Rect rect = Rect.zero;
    if (buttonAxis == Axis.vertical) {
      rect = const Offset(0.0, 0.0) & Size(shortLength, longLength);
    } else {
      rect = const Offset(0.0, 0.0) & Size(longLength, shortLength);
    }

    // Move [rect] to correct location on screen.
    if (basePageViewRect != Rect.zero) {
      if (buttonAlignment == Alignment.topRight) {
        rect = rect.moveTopRightTo(basePageViewRect.topRight);
      } else if (buttonAlignment == Alignment.topLeft) {
        rect = rect.moveTopLeftTo(basePageViewRect.topLeft);
      }
    }
    else {
      assert(basePageViewRect != null, 'AppData, get buttonArrayRect...error, '
          'basePageViewRect is null.');
    }
    return rect;
  }

  /// Toggles [buttonAxis].
  void toggleButtonAxis() {
    buttonAxis = flipAxis(buttonAxis);
    buttonArrayRect = updateButtonArrayRect();
  }

  /// Toggles [drawLayoutBounds].
  void toggleDrawLayoutBounds() => drawLayoutBounds = !drawLayoutBounds;

  /// Toggles [settingsPageListTileFadeEffect].
  void toggleSettingsPageListTileFadeEffect() =>
      settingsPageListTileFadeEffect = !settingsPageListTileFadeEffect;

  // For diagnostics.
  void printThis() {
    print('AppData, appBarHeightScaleFactor = $appBarHeightScaleFactor');
    print('AppData, basePageViewRect = $basePageViewRect');
    print('AppData, buttonAlignment = $buttonAlignment');
    print('AppData, buttonAxis = $buttonAxis');
    print('AppData, buttonPadding = $buttonPadding');
    print('AppData, buttonPaddingMainAxis = $buttonPaddingMainAxis');
    print('AppData, buttonPaddingMainAxisAlt = $buttonPaddingMainAxisAlt');
    print('AppData, buttonRadius = $buttonRadius');
    print('AppData, buttonSpecList = $buttonSpecList');
    print('AppData, drawLayoutBounds = $drawLayoutBounds');
    print('AppData, settingsPageListTileFadeEffect = '
        '$settingsPageListTileFadeEffect');
    print('AppData, settingsPageListTileIconSize = '
        '$settingsPageListTileIconSize');
    print('AppData, drawLayoutBounds = $drawLayoutBounds');
  }

  /// Updates this using string to determine which field is set to newValue.
  void change({
    required String identifier,
    var newValue,
    bool notify = true,
  }) {
    // Define a map that converts [string] to a class method.
    // ToDo: add functionality for other fields in [AppData] class.
    Map<String, Function> map = {
      'appBarHeightScaleFactor': (double newValue) =>
          appBarHeightScaleFactor = newValue,
      'basePageViewRect': (Rect newValue) => basePageViewRect = newValue,
      'buttonAxis': (newValue) => toggleButtonAxis(),
      'drawLayoutBounds': (newValue) => toggleDrawLayoutBounds(),
      'settingsPageListTileFadeEffect': (newValue) =>
          toggleSettingsPageListTileFadeEffect(),
    };

    // Call the function determined from [map] and update relevant field.
    map[identifier]?.call(newValue);

    if (notify) {
      notifyListeners();
    }
  }
}
