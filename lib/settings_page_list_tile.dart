//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/settings_page_list_tile_clipper.dart';

/// [SettingsPageListTile] implements a draft listTile effect that is
/// able to morph itself and pass around ButtonArray.
class SettingsPageListTile extends StatefulWidget {
  const SettingsPageListTile({Key? key}) : super(key: key);

  @override
  State<SettingsPageListTile> createState() => _SettingsPageListTileState();
}

class _SettingsPageListTileState extends State<SettingsPageListTile> {
  @override
  Widget build(BuildContext context) {
    //  Retrieve [buttonArrayRect] from instance of DataNotifier
    //  further up the widget tree.
    //
    //  [buttonArrayRect] is passed to [SettingsPageListTileClipper] which
    //  calculates the path for ClipPath to use.
    Rect buttonArrayRect = DataNotifier
        .of(context, ValueKey('buttonArrayRect')).data.value;

    //  Construct a morphable ListTile instance using ClipPath.
    //
    //  ValueListenableBuilder rebuilds whenever the scroll position changes,
    //  but the build itself doesn't depend on it.
    return ValueListenableBuilder<double>(
      valueListenable: DataNotifier
          .of(context, ValueKey('scrollController')).data,
      builder: (BuildContext context, double value, __) {
        return Container(
          decoration: BoxDecoration(
            border: AppSettings.drawLayoutBounds
                ? Border.all(width: 0.0, color: Colors.redAccent)
                : null,
          ),
          child: ClipPath(
            clipper: SettingsPageListTileClipper(
              context: context,
              guestRect: buttonArrayRect,
            ),
            child: const Card(
              elevation: 20,
              color: Colors.amber,
              child: ListTile(
                leading: FlutterLogo(size: 72.0),
                title: Text('SettingsPageListTile'),
                trailing: Icon(Icons.more_vert),
              ),
            ),
          ),
        );
        // return ClipPath(
        //   clipper: SettingsPageListTileClipper(
        //     context: context,
        //     guestRect: buttonArrayRect,
        //   ),
        //   child: const Card(
        //     elevation: 20,
        //     color: Colors.amber,
        //     child: ListTile(
        //       leading: FlutterLogo(size: 72.0),
        //       title: Text('SettingsPageListTile'),
        //       trailing: Icon(Icons.more_vert),
        //     ),
        //   ),
        // );
      },
    );
  }
}
