//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/settings_page_list_tile.dart';

class SettingsPageContents extends StatefulWidget {
  const SettingsPageContents({Key? key}) : super(key: key);

  @override
  State<SettingsPageContents> createState() => _SettingsPageContentsState();
}

class _SettingsPageContentsState extends State<SettingsPageContents> {
  final List<Color> colors = const [
    Colors.blueGrey,
    Colors.green,
    Colors.deepOrange,
    Colors.purple,
    Colors.pink,
  ];

  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
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
        ...List<Widget>.generate(1, (int index) {
          return SettingsPageListTile(
            controller: scrollController,
          );
        }),
        ...List<Widget>.generate(15, (int index) {
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
