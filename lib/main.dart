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

  //  [appSettingsData] stores all app settings.
  //
  //  The instance of NotificationDataStore in the build function catches
  //  all notifications of type DataNotification being sent up the widget
  //  tree from SettingsPageListTile and trigger a rebuild of the entire app.
  // AppSettingsData appSettingsData = AppSettingsData();
  // ValueNotifier<AppSettingsData> appSettingsData = ValueNotifier(AppSettingsData());

  @override
  Widget build(BuildContext context) {
    //ToDo: Make NotificationDataStore trigger a rebuild when a notification
    //  is received.
    ValueNotifier<AppSettingsData> appSettingsData = ValueNotifier(AppSettingsData());

    print('_KarKam, drawLayoutBounds in build.................................${appSettingsData.value.drawLayoutBounds}');

    return NotificationDataStore<ValueNotifier<AppSettingsData>, DataNotification>(
        key: const ValueKey('AppSettings'),
        data: appSettingsData,
        child: MaterialApp(
          title: '_KarKam',
          //  BasePage invokes a generic page layout so that a similar UI is
          //  presented for each page (route).
          home: ValueListenableBuilder<AppSettingsData>(
            valueListenable: appSettingsData,
            builder: (BuildContext context, AppSettingsData value, __) {

              print('_KarKam, drawLayoutBounds in ValueListenableBuilder................${appSettingsData.value.drawLayoutBounds}');
              print('_KarKam, value.drawLayoutBounds in ValueListenableBuilder..........${value.drawLayoutBounds}');

              return BasePage(
                pageSpec: settingsPage,
                // pageSpec: filesPage,
              );
            }
          ),
          // home: BasePage(
          //   pageSpec: settingsPage,
          //   // pageSpec: filesPage,
          // ),
        ),
        // onNotification: appSettingsOnNotification,
        onNotification: (notification) {
          print('_KarKam, NotificationDataStore, notification received...');
          print('_KarKam, drawLayoutBounds before reassignment..........................${appSettingsData.value.drawLayoutBounds}');
          appSettingsData.value = notification.data;
          print('_KarKam, drawLayoutBounds after reassignment...........................${appSettingsData.value.drawLayoutBounds}');
          print('_KarKam, appSettingsData gets updated in SettingsPageLstTile...!');
          return true;
        },
      );
  }
}
