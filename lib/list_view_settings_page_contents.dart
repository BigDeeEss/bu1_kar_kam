//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/list_view_settings_page_list_tile.dart';

//  [SettingsPageContents] creates app settings in the form of a ListView.
class ListViewSettingsPageContents extends StatefulWidget {
  const ListViewSettingsPageContents({Key? key}) : super(key: key);

  @override
  State<ListViewSettingsPageContents> createState() => _ListViewSettingsPageContentsState();
}

class _ListViewSettingsPageContentsState extends State<ListViewSettingsPageContents> {
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
    List<String>.generate(100, (i) => 'Test item $i');

    return DataNotifier(
      key: ValueKey('scrollController'),
      data: scrollPositionNotifier,
      child: ListView(
        controller: scrollController,
        // physics: CustomScrollPhysics(),
        children: <Widget>[
          ...List<Widget>.generate(100, (int index) {
            return ListViewSettingsPageListTile();
          }),
        ]
      ),
    );
  }
}

class CustomScrollPhysics extends ClampingScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override

  @override
  double get maxFlingVelocity => 1000;

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }
}