import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

abstract class AppModel extends ChangeNotifier {
  bool get drawLayoutBounds;

  set drawLayoutBounds(bool value);

  bool get settingsPageListTileFadeEffect;

  set settingsPageListTileFadeEffect(bool value);

  void incrementCounter();

  void toggleDrawLayoutBounds();

  void toggleSettingsPageListTileFadeEffect();

  int get counter;
}

class AppModelImplementation extends AppModel {
  int _counter = 0;

  /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
  ///
  /// Used for debugging widget screen location.
  bool _drawLayoutBounds = true;

  /// [settingsPageListTileFadeEffect] switches in/out the Text fade effect.
  bool _settingsPageListTileFadeEffect = true;

  AppModelImplementation() {
    /// The loading of settings data from file will require some async
    /// initialization, so simulate it here with a Future.delayed function.
    Future.delayed(Duration(seconds: 3))
        .then((_) => GetIt.instance.signalReady(this));
  }

  @override
  int get counter => _counter;

  @override
  bool get drawLayoutBounds => _drawLayoutBounds;

  @override
  set drawLayoutBounds(bool value) => _drawLayoutBounds = value;

  @override
  bool get settingsPageListTileFadeEffect => _settingsPageListTileFadeEffect;

  @override
  set settingsPageListTileFadeEffect(bool value) {
    _settingsPageListTileFadeEffect = value;
  }

  @override
  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  @override
  void toggleDrawLayoutBounds() {
    _drawLayoutBounds = !_drawLayoutBounds;
    notifyListeners();
  }

  @override
  void toggleSettingsPageListTileFadeEffect() {
    _settingsPageListTileFadeEffect = !_settingsPageListTileFadeEffect;
    notifyListeners();
  }
}
