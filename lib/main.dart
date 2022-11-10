//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
// import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/app_settings_callback_and_data.dart';
// import 'package:kar_kam/app_settings_orig.dart';
import 'package:kar_kam/base_page.dart';
// import 'package:kar_kam/global_a_settings.dart';
// import 'package:kar_kam/global_app_settings_devel.dart';
import 'package:kar_kam/lib/data_notification.dart';
import 'package:kar_kam/lib/notification_data_store.dart';
import 'package:kar_kam/page_specs.dart';

//  App start point.
void main() {
  runApp(_KarKam());
}

/// [_KarKam] is the root widget of this project.
///
/// [_KarKam] loads an instance of [BasePage]; content is determined
/// by [pageSpec].
class _KarKam extends StatelessWidget {
  _KarKam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  This instance of GlobalAppSettings stores all app settings.
    //  GlobalAppSettings catches GlobalAppSettingsNotification being sent up
    //  the widget tree from and notifies any relevant widgets below it
    //  of any changes.
    // GlobalASettingsData globalAppSettingsData = GlobalASettingsData();
    AppSettingsData appSettingsData = AppSettingsData();

    //ToDo: Make NotificationDataStore trigger a rebuild when a notification
    //  is received.
    return NotificationDataStore<AppSettingsData, DataNotification>(
        key: const ValueKey('AppSettings'),
        data: appSettingsData,
        child: MaterialApp(
          title: '_KarKam',
          //  BasePage invokes a generic page layout so that a similar UI is
          //  presented for each page (route).
          home: BasePage(
            pageSpec: settingsPage,
            // pageSpec: filesPage,
          ),
        ),
        // onNotification: appSettingsOnNotification,
        onNotification: (notification) {
          print('Test dispatch method---NotificationDataStore in main...complete');
          print(appSettingsData.drawLayoutBounds);
          print(notification);
          print(notification.data);
          print(notification.data.drawLayoutBounds);
          print("test");
          appSettingsData = notification.data;
          print(appSettingsData.drawLayoutBounds);
          print(notification.data.drawLayoutBounds);
          return true;
        },
      );
  }
}
