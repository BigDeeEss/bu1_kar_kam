//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/lib/get_it_service.dart';
import 'package:kar_kam/settings_data.dart';

/// Settings implements saved user preferences with shared_preferences.
class SettingsService extends ChangeNotifier {
  // /// [settingsPageListTileFadeEffect] switches in/out the Text fade effect.
  // bool settingsPageListTileFadeEffect = true;

  SettingsData settingsData = SettingsData();

  SettingsService() {
    settingsData.init();

    /// The loading of settings data from file will require some async
    /// initialization, so simulate it here with a Future.delayed function.
    Future.delayed(const Duration(seconds: 1))
        .then((_) => GetItService.signalReady<SettingsService>(this));
  }

  // void toggleSettingsPageListTileFadeEffect() {
  //   settingsPageListTileFadeEffect = !settingsPageListTileFadeEffect;
  //   notifyListeners();
  // }

  void changeSettings(String str) {
    settingsData.map[str]!();
    notifyListeners();
  }
}
