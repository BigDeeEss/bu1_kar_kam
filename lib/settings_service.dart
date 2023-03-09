import 'package:flutter/foundation.dart';
import 'package:kar_kam/lib/get_it_service.dart';
import 'package:kar_kam/settings.dart';

// abstract class SettingsServiceSeven<T extends SettingsDataSeven> extends ValueNotifier<T> {
//   SettingsServiceSeven(T value) : super(value);
//
//   void change<T>({required String identifier, var newValue});
// }

// class SettingsServiceSeven<T extends SettingsDataSeven> extends ValueNotifier<T>{
//   SettingsServiceSeven(T value)  : super(value) {
//     /// The loading of settings data from file will require some async
//     /// initialization, so simulate it here with a Future.delayed function.
//     Future.delayed(const Duration(seconds: 1))
//         .then((_) => GetItService.signalReady<SettingsServiceSeven>(this));
//   }
//
//   void change<T>({required String identifier, var newValue}) {
//     value.change(identifier: identifier, newValue: newValue);
//   }
// }

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

  void change<T>({required String identifier, var newValue}) {
    value.change(identifier: identifier, newValue: newValue);
    notifyListeners();
  }
}
