//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kar_kam/app_model.dart';

//  Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/base_page.dart';
import 'package:kar_kam/lib/data_notification.dart';
import 'package:kar_kam/lib/notification_data_store.dart';
import 'package:kar_kam/page_specs.dart';

class KarKam extends StatelessWidget {
  const KarKam({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KarKam Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _KarKam(),
    );
  }
}

class _KarKam extends StatefulWidget {
  _KarKam({super.key});

  @override
  State<_KarKam> createState() => _KarKamState();
}

class _KarKamState extends State<_KarKam> {
  /// [appSettingsData] stores all app settings.
  //
  //  The instance of NotificationDataStore catches notifications of type
  //  DataNotification being sent up the widget tree from SettingsPageListTile.
  AppSettings appSettingsData = AppSettings();

  bool test = true;

  @override
  void dispose() {
    print('dispose executing...');
    // GetIt.instance<APSettings>().removeListener(update);

    GetIt.instance<AppModel>().removeListener(update);
    super.dispose();
  }

  @override
  void initState() {
    //  Get AppSettingsData held by GetIt in main.
    //  Access instance of the registered AppSettings (see GetIt in main).
    // GetIt.instance
    //     .isReady<AppSettings>()
    //     .then((_) => GetIt.instance<APSettings>().addListener(update));
    GetIt.instance
        .isReady<AppModel>()
        .then((_) => GetIt.instance<AppModel>().addListener(update));

    super.initState();
  }

  /// The [update] callback is used by the Listener attached to the registered
  /// instance of AppSettings
  // void update() => setState(() => {});
  void update() {
    print('update executing...');
    setState(() {
      print('setState executing...');
      test = !test;
    });
  }

  @override
  Widget build(BuildContext context) {
    //  Wrap FutureBuilder in Material in order to access theme data
    //  for putting the 'has no data' text widget on screen.
    return Material(
      child: FutureBuilder(
        future: GetIt.instance.allReady(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //  The 'has no data' case.
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Waiting for initialisation'),
                SizedBox(
                  height: 16,
                ),
                CircularProgressIndicator(),
              ],
            );
          } else {
            //  The 'has data' case.

            //  NotificationDataStore catches notifications of type DataNotification
            //  being sent up the widget tree from SettingsPageListTile.
            //
            //  A DataNotification sent from SettingsPageListTile contains an updated
            //  instance of AppSettingsData. This update is checked against the original
            //  value and, if different, uploaded by setState.
            return NotificationDataStore<AppSettings, DataNotification>(
              key: const ValueKey('AppSettings'),
              data: appSettingsData,
              child: MaterialApp(
                title: '_KarKam',
                //  BasePage invokes a generic page layout so that a similar UI is
                //  presented for each page (route).
                home: BasePage(
                  pageSpec: homePage,
                  // pageSpec: settingsPage,
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
          }
        },
      ),
    );
  }
}
