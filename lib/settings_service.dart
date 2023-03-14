// Import flutter packages.
import 'package:flutter/foundation.dart';

// Import project-specific files.
import 'package:kar_kam/lib/get_it_service.dart';
import 'package:kar_kam/settings.dart';

/// Implements a Shared Preferences method for accessing stored app data.
class SettingsService<T extends Settings> extends ChangeNotifier
    implements ValueListenable<T> {
  SettingsService(this._value) {
    /// The loading of settings data from file will require some async
    /// initialization, so simulate it here with a Future.delayed function.
    Future.delayed(const Duration(seconds: 1))
        .then((_) => GetItService.signalReady<SettingsService>(this));
  }

  T _value;

  @override
  T get value => _value;
  set value(T newValue) => _value = newValue;

  /// Update settings data, [_value], and notify listeners to trigger rebuild.
  void change<T>({required String identifier, var newValue}) {
    value.change(identifier: identifier, newValue: newValue);
    // ToDo: make change return a bool so that we can notifiy listeners only when there is a change.
    notifyListeners();
  }
}
