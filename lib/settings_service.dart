// Import flutter packages.
import 'package:flutter/foundation.dart';

// Import project-specific files.
import 'package:kar_kam/lib/get_it_service.dart';
import 'package:kar_kam/settings.dart';

/// Implements a Shared Preferences method for accessing stored app data.
class SettingsService extends Settings {
  SettingsService() {
    /// The loading of settings data from file will require some async
    /// initialization, so simulate it here with a Future.delayed function.
    Future.delayed(const Duration(seconds: 1))
        .then((_) => GetItService.signalReady<SettingsService>(this));
  }

  // /// Update settings data, [_value], and notify listeners to trigger rebuild.
  // void change({required String identifier, var newValue, bool notify = true}) {
  //   change(identifier: identifier, newValue: newValue);
  //   // ToDo: make change return a bool so that we can notifiy listeners only when there is a change.
  //   if (notify) {
  //     notifyListeners();
  //   }
  // }
}
