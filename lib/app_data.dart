// Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/button_array.dart';
import 'package:kar_kam/button_specs.dart';
import 'package:kar_kam/lib/map_extension.dart';
import 'package:kar_kam/lib/rect_extension.dart';

/// Stores app data.
class AppData extends ChangeNotifier {
  AppData() {
    buttonCoordinates = List<double>.generate(
      buttonSpecList.length,
      (int index) => 0,
      growable: false,
    );
  }

  // ToDo: uplift [buttonCoordinates] getter from [ButtonArray] class to here.
  // ToDo: change [buttonCoordinates] when appropriate values change as in cycleButtonRadius.
  // ToDo: make [ButtonArray] get rebuilt evey time buttonRect changes.

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

  /// The Rect that represents the layout bounds for [ButtonArray].
  ///
  /// Initially Rect.zero, it is updated on first build.
  Rect buttonArrayRect = Rect.zero;

  /// The button axis in [ButtonArray].
  Axis buttonAxis = Axis.horizontal;

  /// The current coordinates to build ButtonArray.
  late List<double> buttonCoordinates;

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

  /// Defines the padding between tiles.
  double settingsPageListTilePadding = 0.0;

  /// Defines the tile corner radius.
  double settingsPageListTileRadius = 15.0;

  /// Updates this using string to determine which field is set to newValue.
  void change({
    required String identifier,
    var newValue,
    bool notify = true,
  }) {
    // Define a map that can convert [string] to a class method.
    // ToDo: add functionality for other fields in [AppData] class.
    Map<String, Function> map = {
      'appBarHeightScaleFactor': (double newValue) =>
          appBarHeightScaleFactor = newValue,
      'buttonArrayRect': (newValue) =>
          buttonArrayRect = updateButtonArrayRect(),
      'buttonCoordinates': (newValue) =>
          buttonCoordinates = updateButtonCoordinates(),
      'basePageViewRect': (Rect newValue) => basePageViewRect = newValue,
      'buttonAlignment': (newValue) => cycleButtonAlignment(),
      'buttonAxis': (newValue) => toggleButtonAxis(),
      'buttonRadius': (newValue) => cycleButtonRadius(),
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

  void cycleButtonAlignment() {
    // Define a map which can convert [buttonAlignment] to another
    // [Alignment] type.
    Map<Alignment, Alignment> map = {
      Alignment.topLeft: Alignment.topRight,
      Alignment.topRight: Alignment.bottomRight,
      Alignment.bottomRight: Alignment.bottomLeft,
      Alignment.bottomLeft: Alignment.topLeft,
    };

    // Do the conversion using [map].
    buttonAlignment = map[buttonAlignment]!;

    // Update [buttonArrayRect].
    buttonArrayRect = updateButtonArrayRect();
  }

  void cycleButtonRadius() {
    // Define a map which can convert an integer to a double that represents
    // a value for [buttonRadius].
    Map<int, double> map = {
      0: 32.5,
      1: 28.0,
    };

    // Use [map], its inverse and the modulus operator to cycle [buttonRadius].
    int buttonRadiusIntRepresentation = map.inverse()[buttonRadius]!;
    buttonRadius = map[(buttonRadiusIntRepresentation + 1) % map.length]!;

    // Update [buttonArrayRect].
    buttonArrayRect = updateButtonArrayRect();

    buttonCoordinates = updateButtonCoordinates();
  }

  // Prints all field values associated with [this] for diagnostic purposes.
  void printThis() {
    print('AppData, appBarHeightScaleFactor = $appBarHeightScaleFactor');
    print('AppData, basePageViewRect = $basePageViewRect');
    print('AppData, buttonAlignment = $buttonAlignment');
    print('AppData, buttonArrayRect = $buttonArrayRect');
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
    print('AppData, settingsPageListTilePadding = '
        '$settingsPageListTilePadding');
    print('AppData, settingsPageListTileRadius = '
        '$settingsPageListTileRadius');
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

  // Calculates the bounding box for [ButtonArray].
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

    Map<Alignment, Function> map = {
      Alignment.topLeft: (Rect rect) =>
          rect.moveTopLeftTo(basePageViewRect.topLeft),
      Alignment.topRight: (Rect rect) =>
          rect.moveTopRightTo(basePageViewRect.topRight),
      Alignment.bottomLeft: (Rect rect) =>
          rect.moveBottomLeftTo(basePageViewRect.bottomLeft),
      Alignment.bottomRight: (Rect rect) =>
          rect.moveBottomRightTo(basePageViewRect.bottomRight),
    };

    if (basePageViewRect != Rect.zero) {
      rect = map[buttonAlignment]?.call(rect);
    } else {
      assert(
          basePageViewRect != null,
          'AppData, get buttonArrayRect...error, '
          'basePageViewRect is null.');
    }

    return rect;
  }

  List<double> updateButtonCoordinates() {
    // A length -- button width plus padding -- for defining [coordinateList].
    // Using two parameters allows for the bounding boxes of buttons to overlap.
    double dim = 2 * (buttonRadius + buttonPaddingMainAxisAlt);

    // Loop over items in [buttonSpecList] and convert each to its
    // corresponding position.
    List<double> coordinateList = [];
    for (int i = 0; i < buttonSpecList.length; i++) {
      coordinateList.add(dim * i);
    }
    return coordinateList;
  }
}
