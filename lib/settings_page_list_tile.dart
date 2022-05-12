//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/settings_page_list_tile_border.dart';
import 'package:kar_kam/lib/data_notifier.dart';

/// [SettingsPageListTile] implements a simple Card-based
/// list tile that is able to move around ButtonArray on scroll.
class SettingsPageListTile extends StatelessWidget {
  const SettingsPageListTile({Key? key}) : super(key: key);

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
          child: Material(
            //  Material requires a unique key so that ValueListenableBuilder
            //  is able to consistently and without error rebuild listTile.
            //  Without a unique key the movement can be juddery.
            //
            //  [SettingsPageListTileWithMaterial] requires the Material widget
            //  in order to correctly convert RenderBox data to an offset
            //  when calculating [localGuestRect]
            //  (settings_page_list_tile_border.dart).
            key: UniqueKey(),
            child: ListTile(
              shape: SettingsPageListTileBorder(
                radius: Radius.circular(AppSettings.buttonRadiusInner/15),
                // borderRadius: BorderRadius.circular(AppSettings.buttonRadiusInner/5),
                context: context,
                guestRect: buttonArrayRect,
                // side: BorderSide(width: 0.0, color: Colors.black, style: BorderStyle.solid),
              ),
              tileColor: Colors.amber[700],
              leading: FlutterLogo(),
              title: Text('SettingsPageListTile'),
              trailing: Icon(Icons.more_vert),
              subtitle: Text('Six'),
            ),
          ),
        );
      },
    );
  }
}
