//  Import flutter packages.

//  Import project-specific files.
import 'package:kar_kam/app_settings_data.dart';
// import 'package:kar_kam/lib/data_notification.dart';
// import 'package:kar_kam/lib/notification_data_store.dart';


//  ToDo: Add instance of AppSettingsData to AppSettings.
class AppSettings {
  /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
  ///
  /// Used for debugging widget screen location.
  bool drawLayoutBounds = true;

  AppSettingsData data = AppSettingsData();

  /// Creates a copy of the current instance of [AppSettings].
  AppSettings copy() {
    AppSettings appSettingsData = AppSettings();
    appSettingsData.drawLayoutBounds = drawLayoutBounds;
    return appSettingsData;
  }

  /// Checks equality between the current instance of [AppSettings]
  /// and other.
  @override
  bool operator ==(Object other) {
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
