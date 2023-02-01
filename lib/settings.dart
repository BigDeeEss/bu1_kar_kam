import 'package:flutter/material.dart';
import 'package:kar_kam/lib/get_it_service.dart';

/// Settings implements saved user preferences with shared_preferences.
class Settings extends ChangeNotifier {
  /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
  ///
  /// Used for debugging widget screen location.
  bool drawLayoutBounds = true;

  /// [settingsPageListTileFadeEffect] switches in/out the Text fade effect.
  bool settingsPageListTileFadeEffect = true;

  Settings() {
    /// The loading of settings data from file will require some async
    /// initialization, so simulate it here with a Future.delayed function.
    Future.delayed(const Duration(seconds: 1))
        .then((_) => GetItService.signalReady<Settings>(this));
  }

  // @override
  void toggleDrawLayoutBounds() {
    drawLayoutBounds = !drawLayoutBounds;
    notifyListeners();
  }

  // @override
  void toggleSettingsPageListTileFadeEffect() {
    settingsPageListTileFadeEffect = !settingsPageListTileFadeEffect;
    notifyListeners();
  }
}
