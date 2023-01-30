import 'package:flutter/material.dart';
import 'package:kar_kam/lib/get_it_service.dart';

/// AppModel implements saved user preferences with shared_preferences.
class AppModel extends ChangeNotifier {
  /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
  ///
  /// Used for debugging widget screen location.
  bool drawLayoutBounds = true;

  /// [settingsPageListTileFadeEffect] switches in/out the Text fade effect.
  bool settingsPageListTileFadeEffect = true;

  AppModel() {
    /// The loading of settings data from file will require some async
    /// initialization, so simulate it here with a Future.delayed function.
    Future.delayed(const Duration(seconds: 1))
        .then((_) => GetItService.signalReady<AppModel>(this));
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
