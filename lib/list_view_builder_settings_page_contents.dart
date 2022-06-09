//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/list_view_builder_settings_page_list_tile.dart';

class ListViewBuilderSettingsPageContents extends StatefulWidget {
  const ListViewBuilderSettingsPageContents({Key? key}) : super(key: key);

  @override
  State<ListViewBuilderSettingsPageContents> createState() => _ListViewBuilderSettingsPageContentsState();
}

class _ListViewBuilderSettingsPageContentsState extends State<ListViewBuilderSettingsPageContents> {
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
    print('ListViewBuilderSettingsPageContents');
    return DataNotifier(
      key: ValueKey('scrollController'),
      data: scrollPositionNotifier,
      child: ListView.builder(
        controller: scrollController,
        itemCount: 100,
        itemBuilder: (context, index) {
          return ListViewBuilderSettingsPageListTile(index: index);
        },
      ),
    );
  }
}
