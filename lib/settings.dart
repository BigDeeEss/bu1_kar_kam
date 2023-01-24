//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//  Import project-specific files.
import 'package:kar_kam/app_model.dart';
import 'package:kar_kam/base_page.dart';
import 'package:kar_kam/page_specs.dart';

class Settings extends StatefulWidget {
  const Settings({
    Key? key,
    // required this.child,
  }) : super(key: key);

  // final Widget child;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void dispose() {
    GetIt.instance<AppModel>().removeListener(update);

    super.dispose();
  }

  @override
  void initState() {
    //  Access the instance of the registered AppModel
    //  As we don't know for sure if AppModel is already ready we use the
    //  then method to add a listener only when it is ready.
    GetIt.instance
        .isReady<AppModel>()
        .then((_) => GetIt.instance<AppModel>().addListener(update));

    print('Executing initState in _SettingsState...');
    super.initState();
  }

  /// The [update] callback is used by the Listener attached to the registered
  /// instance of AppModel.
  // void update() => setState(() => {});
  void update() {
    print('Executing update in _SettingsState...');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('build in _SettingsState...');
    return Material(
      child: FutureBuilder(
        future: GetIt.instance.allReady(),
        builder: (context, snapshot) {
          print('builder in _SettingsState...');
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
            return MaterialApp(
              title: '_KarKam',
              //  BasePage invokes a generic page layout so that a similar UI is
              //  presented for each page (route).
              home: ValueListenableBuilder<bool>(
                valueListenable: GetIt.instance<AppModel>().drawLayoutBounds,
                builder: (context, value, _) {
                  print(value);
                  return BasePage(
                    key: UniqueKey(),
                    // pageSpec: homePage,
                    pageSpec: settingsPage,
                    // pageSpec: filesPage,
                  );
                }
                // builder: (BuildContext context, bool value) {
                //   return BasePage(
                //     // pageSpec: homePage,
                //     pageSpec: settingsPage,
                //     // pageSpec: filesPage,
                //   );
                // },
              ),
            );
          }
        },
      ),
    );
  }
}
