//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/settings_page_list_tile_border.dart';

class SettingsPageListTileWithMaterial extends StatelessWidget {
  const SettingsPageListTileWithMaterial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Rect buttonArrayRect = DataNotifier
        .of(context, ValueKey('buttonArrayRect')).data.value;

    return ValueListenableBuilder<double>(
      valueListenable: DataNotifier
          .of(context, ValueKey('scrollController')).data,
      builder: (BuildContext context, double value, __) {
        return Container(
          key: UniqueKey(),
          decoration: BoxDecoration(
            border: AppSettings.drawLayoutBounds
                ? Border.all(width: 0.0, color: Colors.redAccent)
                : null,
          ),
          child: Material(
            key: UniqueKey(),
            child: ListTile(
              shape: SettingsPageListTileBorder(
                borderRadius: BorderRadius.circular(AppSettings.buttonRadiusInner),
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
