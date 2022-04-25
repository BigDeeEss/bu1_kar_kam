//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/clipped_rounded_rectangle_border.dart';
import 'package:kar_kam/lib/data_notifier.dart';

class SettingsPageListTileThree extends StatelessWidget {
  const SettingsPageListTileThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Rect buttonArrayRect = DataNotifier
        .of(context, ValueKey('buttonArrayRect')).data.value;
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
          child: Card(
            key: UniqueKey(),
            shape: ClippedRoundedRectangleBorder(
              context: context,
              // side: BorderSide(width: 5.0, color: Colors.black, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(AppSettings.buttonRadiusInner),
              guestRect: buttonArrayRect,
            ),
            // elevation: value,
            // key: globalKey,
            color: Colors.amber[700],
            child: ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text('SettingsPageListTile'),
              trailing: Icon(Icons.more_vert),
              subtitle: Text('sgfsaifj b dshv'),
            ),
          ),
        );
      },
    );
  }
}
