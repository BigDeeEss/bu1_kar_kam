//  Import flutter packages.
import 'package:kar_kam/lib/data_notification.dart';
import 'package:kar_kam/lib/notification_data_store.dart';

class AppSettingsData {
  /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
  ///
  /// Used for debugging widget screen location.
  bool drawLayoutBounds = true;

// bool get drawLayoutBounds => drawLayoutBoundsVal;
}


/// [NotificationDataStoreCallback] defines the form of callback that is
/// acceptable to [NotificationDataStore].
NotificationDataStoreCallback<DataNotification> appSettingsOnNotification =
  (notification) {
    print('Test dispatch method---NotificationDataStore...complete');
    return false;
  };
