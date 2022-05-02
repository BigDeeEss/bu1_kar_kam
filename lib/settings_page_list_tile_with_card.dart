//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/settings_page_list_tile_border.dart';
import 'package:kar_kam/lib/data_notifier.dart';

/// [SettingsPageListTileWithCard] implements a simple Card-based
/// list tile that is able to move around ButtonArray on scroll.
class SettingsPageListTileWithCard extends StatelessWidget {
  const SettingsPageListTileWithCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Rect buttonArrayRect = DataNotifier
        .of(context, ValueKey('buttonArrayRect')).data.value;

    //  Use ValueListenableBuilder, triggering on ScrollController
    //  (settings_page_contents.dart), to rebuild [SettingsPageListTileBorder].
    //  [SettingsPageListTileBorder] is the engine behind a sliding list tile.
    return ValueListenableBuilder<double>(
      valueListenable: DataNotifier
          .of(context, ValueKey('scrollController')).data,
      builder: (BuildContext context, double value, __) {
        return Container(
          //  Draw boundng box.
          decoration: BoxDecoration(
            border: AppSettings.drawLayoutBounds
                ? Border.all(width: 0.0, color: Colors.redAccent)
                : null,
          ),
          child: Card(
            //  Card requires a unique key so that ValueListenableBuilder
            //  is able to consistently and without error rebuild listTile.
            //  Without a unique key the movement can be juddery.
            key: UniqueKey(),
            shape: SettingsPageListTileBorder(
              borderRadius: BorderRadius.circular(AppSettings.buttonRadiusInner),
              context: context,
              guestRect: buttonArrayRect,
              // side: BorderSide(width: 0.0, color: Colors.black, style: BorderStyle.solid),
            ),
            color: Colors.amber[700],
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('SettingsPageListTile'),
              trailing: Icon(Icons.more_vert),
              subtitle: Text('Four'),
            ),
          ),
        );
      },
    );
  }
}
