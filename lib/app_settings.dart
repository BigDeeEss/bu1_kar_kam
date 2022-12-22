//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//  Import project-specific files.
import 'package:kar_kam/lib/data_notification.dart';
import 'package:kar_kam/lib/notification_data_store.dart';

abstract class APSettings extends ChangeNotifier {
  bool get settingsPageListTileFadeEffect;

  void set settingsPageListTileFadeEffect(bool value);

  void toggleSettingsPageListTileFadeEffect();
}

class AppSettings extends APSettings {
  AppSettings() {
    /// lets pretend we have to do some async initialization
    // GetIt.instance.signalReady(this);
    /// lets pretend we have to do some async initialization
    // Future.delayed(const Duration(seconds: 1)).then((_) => GetIt.instance.signalReady(this));
  }

  /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
  ///
  /// Used for debugging widget screen location.
  bool drawLayoutBounds = true;

  /// [settingsPageListTileFadeEffect] switches in/out the Text fade effect.
  bool _settingsPageListTileFadeEffect = true;

  void toggleSettingsPageListTileFadeEffect() {
    // print('Executing toggleSettingsPageListTileFadeEffect...');
    _settingsPageListTileFadeEffect = !_settingsPageListTileFadeEffect;
    notifyListeners();
  }

  /// Creates a copy of the current instance of [AppSettings].
  AppSettings copy() {
    AppSettings appSettingsData = AppSettings();
    appSettingsData.drawLayoutBounds = drawLayoutBounds;
    return appSettingsData;
  }

  @override
  bool get settingsPageListTileFadeEffect => _settingsPageListTileFadeEffect;

  @override
  void set settingsPageListTileFadeEffect(bool value) {
    _settingsPageListTileFadeEffect = value;
  }

    /// Checks equality between the current instance of [AppSettings]
    /// and other.
    @override
    bool operator == (Object other) {
      return (other is AppSettings)
          && other.drawLayoutBounds == drawLayoutBounds;
    }
}


// /// [NotificationDataStoreCallback] defines the form of callback that is
// /// acceptable to [NotificationDataStore].
// NotificationDataStoreCallback<DataNotification> appSettingsOnNotification =
//   (notification) {
//     print('Test dispatch method---NotificationDataStore...complete');
//     // data = notification.data
//     print(notification);
//     print(notification.data);
//     return true;
//   };
