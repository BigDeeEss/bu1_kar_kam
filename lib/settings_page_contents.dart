//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/data_notification.dart';
import 'package:kar_kam/notification_notifier.dart';
import 'package:kar_kam/settings_page_list_tile.dart';

/// [SettingsPageContents] implements a bespoke settings page by calling
/// [_SettingsPageContentsList]. This introduces an additional layer in the
/// widget tree for an instance of NotificationNotifier.
class SettingsPageContents extends StatelessWidget {
  SettingsPageContents({Key? key}) : super(key: key);

  ValueNotifier<double> notificationData = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    return NotificationNotifier<ScrollNotification, double>(
      child: _SettingsPageContentsList(),
      notificationData: notificationData,
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          notificationData.value = notification.metrics.pixels;
        }
        //  Return true to stop notifications of this type
        //  continuing up the widget tree.
        return true;
      },
    );
  }
}

class _SettingsPageContentsList extends StatelessWidget {
  const _SettingsPageContentsList({
    Key? key,
  }) : super(key: key);

  final List<Color> colors = const [
    Colors.blueGrey,
    Colors.green,
    Colors.deepOrange,
    Colors.purple,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    // print(NotificationNotifier.of <DataNotification, Rect?> (context).notificationData);
    // print(buttonGlobalKey);
    // print(buttonGlobalKey.globalPaintBounds);
    return ListView(
      children: [
        // Card(
        //   child: Opacity(
        //     opacity: 0.5,
        //     child: ListTile(
        //       title: Text('Test.'),
        //     ),
        //   ),
        // ),
        // Card(
        //   child: Opacity(
        //     opacity: 0.5,
        //     child: ListTile(
        //       title: Text('Test.'),
        //     ),
        //   ),
        // ),
        // Card(
        //   child: Opacity(
        //     opacity: 0.5,
        //     child: ListTile(
        //       title: Text('Test.'),
        //     ),
        //   ),
        // ),
        // Card(
        //   child: Opacity(
        //     opacity: 0.5,
        //     child: ListTile(
        //       title: Text('Test.'),
        //     ),
        //   ),
        // ),
        // Card(
        //   child: Opacity(
        //     opacity: 0.5,
        //     child: ListTile(
        //       title: Text('Test.'),
        //     ),
        //   ),
        // ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        SettingsPageListTile(color: Colors.yellow),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Card(
          child: Opacity(
            opacity: 0.5,
            child: ListTile(
              title: Text('Test.'),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            color: colors[1],
          ),
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        // SettingsPageListTile(),
        // ValueListenableBuilder<Rect?>(
        //   valueListenable: NotificationNotifier.of <DataNotification, Rect?> (context).notificationData,
        //   builder: (BuildContext context, Rect? value, __,){
        //     return Container(
        //       height: value?.height ?? 30,
        //       width: 50,
        //       alignment: Alignment.center,
        //       color: colors[4],
        //       // child: Text('${value?.height ?? 30}'),
        //       child: Text('${value}, ${value?.height ?? 30}'),
        //     );
        //   },
        // ),
        ValueListenableBuilder<double>(
          valueListenable: NotificationNotifier.of <ScrollNotification, double> (context).notificationData,
          builder: (BuildContext context, double value, __,){
            return Container(
              height: 20.0 + 80 * math.pow(math.cos(value/50), 2),
              width: 50,
              alignment: Alignment.center,
              color: colors[3],
            );
          },
        ),
        // SettingsPageListTile(),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        // SettingsPageListTile(color: Colors.yellow),
        Card(
          child: ListTile(
            title: Text("Codesinsider.com"),
          ),
          elevation: 8,
          shadowColor: Colors.green,
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        // SettingsPageListTile(),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        SettingsPageListTile(color: Colors.yellow),
        ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          selected: true,
          selectedTileColor: Colors.grey[300],
          leading: FlutterLogo(),
          title: Text('ListTile'),
        ),
        Card(
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            selected: true,
            selectedTileColor: Colors.grey[300],
            leading: FlutterLogo(),
            title: Text('ListTile'),
            subtitle: SizedBox(height: 77,),
          ),
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Card(
          child: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            color: colors[2],
            child: Text('2'),
          ),
        ),
        Card(
          child: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            color: colors[2],
            child: Text('1'),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Card(
          child: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            color: colors[2],
          ),
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[1],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[2],
        ),
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          color: colors[0],
        ),
      ],
    );
  }
}
