//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//  Import project-specific files.
import 'package:kar_kam/settings.dart';
import 'package:kar_kam/lib/data_notification.dart';
import 'package:kar_kam/lib/notification_data_store.dart';
import 'package:kar_kam/page_specs.dart';

import 'base_page.dart';

/// [KarKam] is the root widget of this application.
class KarKam extends StatelessWidget {
  const KarKam({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const _KarKam(),
    );
  }
}

class _KarKam extends StatefulWidget {
  const _KarKam({super.key});

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
    return NotificationDataStore<SettingsService, DataNotification>(
      key: const ValueKey('AppSettings'),
      data: appSettingsData,
      child: FutureBuilder(
        future: GetIt.instance.allReady(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BasePage(
              pageSpec: settingsPage,
              // pageSpec: filesPage,
            );
          } else {
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
          }
        }
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




    // return FutureBuilder(
    //   future: GetIt.instance.allReady(),
    //   builder: (context, snapshot) {
    //     return NotificationDataStore<SettingsService, DataNotification>(
    //       key: const ValueKey('AppSettings'),
    //       data: appSettingsData,
    //       child: BasePage(
    //         pageSpec: settingsPage,
    //         // pageSpec: filesPage,
    //       ),
    //       onNotification: (notification) {
    //         //  Compare old to new and trigger setState if different.
    //         if (!(appSettingsData == notification.data)) {
    //           setState(() {
    //             appSettingsData = notification.data;
    //           });
    //         }
    //         return true;
    //       },
    //     );
    //   },
    // );
  }
}
