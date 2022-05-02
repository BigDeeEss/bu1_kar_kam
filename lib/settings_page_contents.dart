//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/settings_page_list_tile_with_card.dart';
import 'package:kar_kam/settings_page_list_tile_with_material.dart';
import 'package:kar_kam/lib/data_notifier.dart';

//  [SettingsPageContents] creates app settings in the form of a ListView.
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

  /// [scrollController] is added to the ListView instance below in order
  /// to get the scroll position offset value.
  final ScrollController scrollController = ScrollController();

  /// [scrollPositionNotifier] is passed to an instance of DataNotifier in
  /// order to pass the scroll position down to SettingsPageListTile.
  final ValueNotifier<double> scrollPositionNotifier = ValueNotifier(0.0);

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //  Update [scrollPositionNotifier] with new scroll position whenever
    //  [scrollController] registers a change.
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
          ...List<Widget>.generate(20, (int index) {
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
          // ...List<Widget>.generate(1, (int index) {
          //   return SettingsPageListTileOne();
          // }),
          // ...List<Widget>.generate(1, (int index) {
          //   return SettingsPageListTileTwo();
          // }),
          // ...List<Widget>.generate(1, (int index) {
          //   return SettingsPageListTileThree();
          // }),
          // ...List<Widget>.generate(5, (int index) {
          //   return SettingsPageListTileWithCard();
          // }),
          ...List<Widget>.generate(1, (int index) {
            return SettingsPageListTileWithMaterial();
          }),
          // ...List<Widget>.generate(1, (int index) {
          //   return SettingsPageListTileFive(
          //     title: ' #$index ',
          //   );
          // }),
          ...List<Widget>.generate(20, (int index) {
            return Opacity(
              opacity: 0.5,
              child: Card(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  title: Text('Test $index'),
                  tileColor: colors[index % colors.length],
                ),
              ),
            );
          }),
        ]
      ),
    );
  }
}
