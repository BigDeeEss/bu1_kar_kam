//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:kar_kam/lib/data_notifier.dart';

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

  final ScrollController scrollController = ScrollController();

  final ValueNotifier<double> scrollPositionNotifier = ValueNotifier(0.0);

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      scrollPositionNotifier.value = scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DataNotifier(
      key: ValueKey('scrollController'),
      data: scrollPositionNotifier,
      child: ListView(
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
          ...List<Widget>.generate(20, (int index) {
            return SettingsPageListTile();
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
      ),
    );
    // return ListView(
    //   controller: scrollController,
    //   children: <Widget>[
    //     ...List<Widget>.generate(5, (int index) {
    //       return Opacity(
    //         opacity: 0.5,
    //         child: Card(
    //           child: ListTile(
    //             title: Text('Test $index'),
    //             tileColor: colors[index % colors.length],
    //           ),
    //         ),
    //       );
    //     }),
    //     ...List<Widget>.generate(30, (int index) {
    //       return SettingsPageListTile();
    //       // return Container(
    //       //   child: Text('$index')
    //       // );
    //     }),
    //     ...List<Widget>.generate(5, (int index) {
    //       return Opacity(
    //         opacity: 0.5,
    //         child: Card(
    //           child: ListTile(
    //             title: Text('Test $index'),
    //             tileColor: colors[index % colors.length],
    //           ),
    //         ),
    //       );
    //     }),
    //   ]
    // );
  }
}
