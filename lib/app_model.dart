import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

abstract class AppModel extends ChangeNotifier {
  bool get settingsPageListTileFadeEffect;

  void set settingsPageListTileFadeEffect(bool value);

  void incrementCounter();

  void toggleSettingsPageListTileFadeEffect();

  int get counter;
}

class AppModelImplementation extends AppModel {
  int _counter = 0;

  /// [settingsPageListTileFadeEffect] switches in/out the Text fade effect.
  bool _settingsPageListTileFadeEffect = true;

  AppModelImplementation() {
    /// lets pretend we have to do some async initialization
    print('executing AppModelImplementation constructor...');
    Future.delayed(Duration(seconds: 3)).then((_) => GetIt.instance.signalReady(this));
  }

  @override
  int get counter => _counter;

  @override
  bool get settingsPageListTileFadeEffect => _settingsPageListTileFadeEffect;

  @override
  void set settingsPageListTileFadeEffect(bool value) {
    _settingsPageListTileFadeEffect = value;
  }

  @override
  void incrementCounter() {
    _counter++;
    print(_counter);
    notifyListeners();
  }

  @override
  void toggleSettingsPageListTileFadeEffect() {
    print('Toggling _settingsPageListTileFadeEffect...');
    print(_settingsPageListTileFadeEffect);
    _settingsPageListTileFadeEffect = !_settingsPageListTileFadeEffect;
    print(_settingsPageListTileFadeEffect);
    notifyListeners();
  }
}
