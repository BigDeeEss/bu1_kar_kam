//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/app_model.dart';
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/base_page.dart';
import 'package:kar_kam/lib/get_it_service.dart';
import 'package:kar_kam/lib/data_notification.dart';
import 'package:kar_kam/lib/notification_data_store.dart';
import 'package:kar_kam/page_specs.dart';
import 'package:kar_kam/settings.dart';

/// KarKam is a StatelessWidget wrapper for _KarKam, which encapsulates
/// a FutureBuilder that waits for saved app settings data to be loaded.
class KarKam extends StatelessWidget {
  const KarKam({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KarKam Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const _KarKam(),
    );
  }
}

/// _KarKam builds a FutureBuilder widget in order to take account of
/// the async process associated with loading saved app setting data.
class _KarKam extends StatefulWidget {
  const _KarKam({Key? key}) : super(key: key);

  @override
  State<_KarKam> createState() => _KarKamState();
}

class _KarKamState extends State<_KarKam> {
  /// [appSettingsData] stores all app settings.
  //
  //  The instance of NotificationDataStore catches notifications of type
  //  DataNotification being sent up the widget tree from SettingsPageListTile.
  AppSettings appSettingsData = AppSettings();

  @override
  void dispose() {
    print('executing dispose...');
    // GetIt.instance<AppModel>().removeListener(update);
    GetItService.dispose<AppModel>(update);
    // // GetIt.instance<AppModel>().removeListener(update);
    // GetItService.dispose<AppModel>(update);

    super.dispose();
  }

  @override
  void initState() {


    //  Access the instance of the registered AppModel
    //  As we don't know for sure if AppModel is already ready we use the
    //  then method to add a listener only when it is ready.
    GetItService.addListener<AppModel>(() {});
    // GetIt.instance
    //     .isReady<AppModel>()
    //     .then((_) => GetIt.instance<AppModel>().addListener(update));

    super.initState();
  }

  /// The [update] callback is used by the Listener attached to the registered
  /// instance of AppModel.
  void update() => setState(() => {});

  @override
  Widget build(BuildContext context) {
    //  Wrap FutureBuilder in Material widget in order to access theme data
    //  for putting the 'has no data' text widget on screen. Without this
    //  the default is rather ugly.
    return Settings(
      child: Material(
        child: FutureBuilder(
          future: GetItService.allReady(),
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
              //
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
      ),
    );
    // return Material(
    //   child: FutureBuilder(
    //     future: GetIt.instance.allReady(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         //  The 'has no data' case.
    //         return Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Text('Waiting for initialisation'),
    //             SizedBox(
    //               height: 16,
    //             ),
    //             CircularProgressIndicator(),
    //           ],
    //         );
    //       } else {
    //         //  The 'has data' case.
    //         //
    //         //  NotificationDataStore catches notifications of type DataNotification
    //         //  being sent up the widget tree from SettingsPageListTile.
    //         //
    //         //  A DataNotification sent from SettingsPageListTile contains an updated
    //         //  instance of AppSettingsData. This update is checked against the original
    //         //  value and, if different, uploaded by setState.
    //         return NotificationDataStore<AppSettings, DataNotification>(
    //           key: const ValueKey('AppSettings'),
    //           data: appSettingsData,
    //           child: MaterialApp(
    //             title: '_KarKam',
    //             //  BasePage invokes a generic page layout so that a similar UI is
    //             //  presented for each page (route).
    //             home: BasePage(
    //               pageSpec: homePage,
    //               // pageSpec: settingsPage,
    //               // pageSpec: filesPage,
    //             ),
    //           ),
    //           onNotification: (notification) {
    //             //  Compare old to new and trigger setState if different.
    //             if (!(appSettingsData == notification.data)) {
    //               setState(() {
    //                 appSettingsData = notification.data;
    //               });
    //             }
    //             return true;
    //           },
    //         );
    //       }
    //     },
    //   ),
    // );
  }
}
