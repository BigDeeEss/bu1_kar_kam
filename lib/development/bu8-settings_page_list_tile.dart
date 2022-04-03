//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/clipped_rounded_rectangle_border.dart';
import 'package:kar_kam/lib/data_notifier.dart';

class SettingsPageListTile extends StatelessWidget {
  const SettingsPageListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  Retrieve buttonArrayRect from instance of DataNotifier
    //  further up the widget tree.
    Rect buttonArrayRect = DataNotifier
        .of(context, ValueKey('buttonArrayRect')).data.value;
    // return Container(child: Text('Test'),);

    return ValueListenableBuilder<double>(
      valueListenable: DataNotifier
          .of(context, ValueKey('scrollController'))
          .data,
      builder: (BuildContext context, double value, __) {
        // print('_SettingsPageListTileState: build: buttonArrayRect = $buttonArrayRect');
        // print('_SettingsPageListTile: build: value = $value');
        // print(value % 5 + 10);
        return Card(
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(value % 50 + 10),
          // ),
          shape: ClippedRoundedRectangleBorder(
            pos: value,
            context: context,
            side: BorderSide(width: 2.0, color: Colors.black, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(value % 10 + 10),
            // borderRadius: BorderRadius.circular(10),
            guestRect: buttonArrayRect,
          ),
          elevation: 20,
          color: Colors.amber,
          child: const ListTile(
            leading: FlutterLogo(size: 72.0),
            title: Text('SettingsPageListTile'),
            trailing: Icon(Icons.more_vert),
          ),
        );
    });
  }
}
