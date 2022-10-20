//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/lib/data_notification.dart';
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/settings_page_list_tile.dart';

/// [SettingsPageContents] implements a settings page with
/// tiles that are able scroll around (not behind) [buttonArray].
class SettingsPageContents extends StatefulWidget {
  const SettingsPageContents({Key? key}) : super(key: key);

  @override
  State<SettingsPageContents> createState() => _SettingsPageContentsState();
}

class _SettingsPageContentsState extends State<SettingsPageContents> {
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
    //  Get [buttonArrayRect] from NataNotifier in [BasePage].
    Rect? buttonArrayRect =
        DataNotifier.of(context, ValueKey('buttonArrayRect')).data.value;

    //  Get [basePageViewRect] from NataNotifier in [BasePage].
    Rect? basePageViewRect =
        DataNotifier.of(context, ValueKey('basePageViewRect')).data.value;

    //  Generate a temporary list of tiles to build.
    List<Widget> tileList = [
      ...List<Widget>.generate(5, (int index) {
        return SettingsPageListTile(
          basePageViewRect:
              basePageViewRect ?? Offset.zero & MediaQuery.of(context).size,
          guestRect: buttonArrayRect,
          height: 75.0,
          index: index,
          leading: Icon(
            Icons.favorite,
            size: AppSettings.settingsPageListTileIconSize,
          ),
        );
      }),
      SettingsPageListTile(
          basePageViewRect:
              basePageViewRect ?? Offset.zero & MediaQuery.of(context).size,
          guestRect: buttonArrayRect,
          height: 75.0,
          index: 5,
          leading: Icon(
            Icons.circle_notifications_outlined,
            size: AppSettings.settingsPageListTileIconSize,
          ),
          onTap:() {
            print('SettingsPageLstTile: tapped...!');
            DataNotification(data: 'drawLayoutBounds').dispatch(context);
            print('SettingsPageLstTile: notification sent...!');
          },
          trailing: Icon(
            Icons.circle_notifications_outlined,
            size: AppSettings.settingsPageListTileIconSize,
          ),
        ),
      ...List<Widget>.generate(100, (int index) {
        return SettingsPageListTile(
          basePageViewRect:
              basePageViewRect ?? Offset.zero & MediaQuery.of(context).size,
          guestRect: buttonArrayRect,
          height: 75.0,
          index: index + 6,
          leading: Icon(
            Icons.favorite,
            size: AppSettings.settingsPageListTileIconSize,
          ),
        );
      }),
    ];

    //  Encapsulate ListViewBuilder in an instance of DataNotifier in order
    //  to pass [scrollPositionNotifier] notifier down to [SettingsPageListTile].
    return DataNotifier(
      key: ValueKey('scrollPosition'),
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
