//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/lib/alignment_extension.dart';
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/lib/settings_page_list_tile_border.dart';

/// [SettingsPageListTile] implements a simple Card-based
/// list tile that is able to move around ButtonArray on scroll.
class SettingsPageListTile extends StatelessWidget {
  SettingsPageListTile({Key? key}) : super(key: key);

  final ValueNotifier<Path> settingsPageListTileBorderPath = ValueNotifier(
      Path());

  @override
  Widget build(BuildContext context) {
    Rect buttonArrayRect = DataNotifier
        .of(context, ValueKey('buttonArrayRect'))
        .data
        .value;

    // print(AppSettings.buttonAlignment.isLeft);

    //  Use ValueListenableBuilder, triggering on ScrollController
    //  (settings_page_contents.dart), to rebuild [SettingsPageListTileBorder].
    //  [SettingsPageListTileBorder] is the engine behind a sliding list tile.
    return ValueListenableBuilder<double>(
      valueListenable: DataNotifier
          .of(context, ValueKey('scrollController'))
          .data,
      builder: (BuildContext context, double value, __) {
        // print('settingsPageListTileBorderPath = ${settingsPageListTileBorderPath.value.getBounds()}');
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
            child: Card(
              margin: EdgeInsets.all(0.0),
              shape: SettingsPageListTileBorder(
                radius: Radius.circular(AppSettings.buttonRadiusInner / 15),
                context: context,
                guestRect: buttonArrayRect,
                pathNotifier: settingsPageListTileBorderPath,
                // side: BorderSide(width: 0.0, color: Colors.black, style: BorderStyle.solid),
              ),
              color: Colors.amber[700],
              child: Align(
                alignment: AppSettings.buttonAlignment.isLeft ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: settingsPageListTileBorderPath.value.getBounds().width,
                  child: Row(
                    children: [
                      FlutterLogo(),
                      Text('SettingsPageListTile - success!'),
                      Icon(Icons.more_vert),
                    ],
                  ),
                ),
              ),
              // child: ValueListenableBuilder<Path>(
              //   valueListenable: settingsPageListTileBorderPath,
              //   builder: (BuildContext context, Path value, __) {
              //     Rect rect = value.getBounds();
              //     print('rect = $rect');
              //     return Row(
              //       children: [
              //         FlutterLogo(),
              //         Text('SettingsPageListTile'),
              //         Icon(Icons.more_vert),
              //       ],
              //     );
              //   }
              // ),
              // child: Row(
              //
              //   children: [
              //     SizedBox(
              //       width: settingsPageListTileBorderPath.value.getBounds().width,
              //     )
              //     FlutterLogo(),
              //     Text('SettingsPageListTile'),
              //     Icon(Icons.more_vert),
              //   ],
              // ),
            ),
          ),
        );
      },
    );
  }
}
