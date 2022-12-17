//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//  Import project-specific files.
import 'package:kar_kam/settings.dart';
import 'package:kar_kam/base_page.dart';
import 'package:kar_kam/lib/data_notification.dart';
import 'package:kar_kam/lib/notification_data_store.dart';
import 'package:kar_kam/page_specs.dart';

//  App start point.
void main() {
  //  Define an instance of GetIt and register AppSettings.
  GetIt.instance.registerSingleton<SettingsService>(
    SettingsService(),
    signalsReady: true,
  );

  //  Run the app.
  runApp(_KarKam());
}

/// [_KarKam] is the root widget of this project.
///
/// [_KarKam] loads an instance of [BasePage] with content determined
/// by [pageSpec].
class _KarKam extends StatefulWidget {
  _KarKam({Key? key}) : super(key: key);

  @override
  State<_KarKam> createState() => _KarKamState();
}

class _KarKamState extends State<_KarKam> {
  /// [appSettingsData] stores all app settings.
  //
  //  The instance of NotificationDataStore catches notifications of type
  //  DataNotification being sent up the widget tree from SettingsPageListTile.
  SettingsService appSettingsData = SettingsService();

  /// The [update] callback is used by the Listener attached to the registered
  /// instance of AppSettings
  // void update() => setState(() => {});
  void update() {
    print('update executing...');
    setState(() => {});
  }

  @override
  void dispose() {
    GetIt.instance<SettingsService>().removeListener(update);

    super.dispose();
  }

  @override
  void initState() {
    //  Get AppSettingsData held by GetIt in main.
    //  Access instance of the registered AppSettings (see GetIt in main).
    GetIt.instance
        .isReady<SettingsService>()
        .then((_) => GetIt.instance<SettingsService>().addListener(update));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: GetIt.instance.allReady(),
        builder: (context, snapshot) {
          // if (snapshot.hasData) {
            //  NotificationDataStore catches notifications of type DataNotification
            //  being sent up the widget tree from SettingsPageListTile.
            //
            //  A DataNotification sent from SettingsPageListTile contains an updated
            //  instance of AppSettingsData. This update is checked against the original
            //  value and, if different, uploaded by setState.
            return NotificationDataStore<SettingsService, DataNotification>(
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
              onNotification: (notification) {
                //  Compare old to new and trigger setState if different.
                if (!(appSettingsData == notification.data)) {
                  setState(() {
                    appSettingsData = notification.data;
                  });
                }
                return true;
              },
            );
          // } else {
          //   return Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       // Text('Waiting for initialisation'),
          //       SizedBox(
          //         height: 16,
          //       ),
          //       CircularProgressIndicator(),
          //     ],
          //   );
          // }
        },
      ),
    );
    // //  NotificationDataStore catches notifications of type DataNotification
    // //  being sent up the widget tree from SettingsPageListTile.
    // //
    // //  A DataNotification sent from SettingsPageListTile contains an updated
    // //  instance of AppSettingsData. This update is checked against the original
    // //  value and, if different, uploaded by setState.
    // return NotificationDataStore<AppSettings, DataNotification>(
    //   key: const ValueKey('AppSettings'),
    //   data: appSettingsData,
    //   child: MaterialApp(
    //     title: '_KarKam',
    //     //  BasePage invokes a generic page layout so that a similar UI is
    //     //  presented for each page (route).
    //     home: BasePage(
    //       pageSpec: settingsPage,
    //       // pageSpec: filesPage,
    //     ),
    //   ),
    //   onNotification: (notification) {
    //     //  Compare old to new and trigger setState if different.
    //     if (!(appSettingsData == notification.data)) {
    //       setState(() {
    //         appSettingsData = notification.data;
    //       });
    //     }
    //     return true;
    //   },
    // );
  }
}
