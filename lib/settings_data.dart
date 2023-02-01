//  Import flutter packages.

class SettingsData {
  // SettingsData() : map = {'drawLayoutBounds': () => toggleDrawLayoutBounds()};
  // SettingsData() : init();

  /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
  ///
  /// Used for debugging widget screen location.
  bool drawLayoutBounds = true;

  /// [settingsPageListTileFadeEffect] switches in/out the Text fade effect.
  bool settingsPageListTileFadeEffect = true;

  late Map<String, Function> map;

  void toggleDrawLayoutBounds() => drawLayoutBounds = !drawLayoutBounds;

  void init() {
    map = {'drawLayoutBounds': () => toggleDrawLayoutBounds()};
  }
}