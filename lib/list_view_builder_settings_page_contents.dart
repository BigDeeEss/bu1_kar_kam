//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/list_view_builder_settings_page_list_tile.dart';

class ListViewBuilderSettingsPageContents extends StatefulWidget {
  const ListViewBuilderSettingsPageContents({Key? key}) : super(key: key);

  @override
  State<ListViewBuilderSettingsPageContents> createState() =>
      _ListViewBuilderSettingsPageContentsState();
}

class _ListViewBuilderSettingsPageContentsState
    extends State<ListViewBuilderSettingsPageContents> {
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
    Rect buttonArrayRect = DataNotifier
        .of(context, ValueKey('buttonArrayRect'))
        .data
        .value;

    double width = MediaQuery.of(context).size.width;
    double appBarHeight =
        MediaQuery.of(context).padding.top + kToolbarHeight;
    print('appBarHeight = $appBarHeight');
    // Offset offset = Offset(0.0, -appBarHeight);

    List<Widget> tileList = [...List<Widget>.generate(100, (int index) {
      return ListViewBuilderSettingsPageListTile(
        guestRect: buttonArrayRect,
        index: index,
        maxWidth: width,
        // offset: offset,
      );
    })];

    return DataNotifier(
      key: ValueKey('scrollController'),
      data: scrollPositionNotifier,
      child: ListView.builder(
        controller: scrollController,
        itemCount: tileList.length,
        itemBuilder: (context, index) {
          return tileList[index];
        },
      ),
    );
  }
}
