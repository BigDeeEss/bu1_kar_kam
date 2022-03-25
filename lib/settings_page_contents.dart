//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/settings_page_list_tile.dart';


class SettingsPageContents extends StatefulWidget {
  const SettingsPageContents({Key? key}) : super(key: key);

  @override
  _SettingsPageContentsState createState() => _SettingsPageContentsState();
}

class _SettingsPageContentsState extends State<SettingsPageContents> {
  final List<Color> colors = const [
    Colors.blueGrey,
    Colors.green,
    Colors.deepOrange,
    Colors.purple,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      // children: List<Widget>.generate(5, (int index) => Container()),
      children: <Widget>[
        ...List<Widget>.generate(5, (int index) {
          return Opacity(
            opacity: 0.5,
            child: Card(
              child: ListTile(
                title: Text('Test $index'),
                tileColor: colors[index % colors.length],
              ),
            ),
          );
        }),
        ...List<Widget>.generate(30, (int index) {
          return SettingsPageListTile();
          // return Container(
          //   child: Text('$index')
          // );
        }),
        ...List<Widget>.generate(5, (int index) {
          return Opacity(
            opacity: 0.5,
            child: Card(
              child: ListTile(
                title: Text('Test $index'),
                tileColor: colors[index % colors.length],
              ),
            ),
          );
        }),
      ]
    );
  }
}
