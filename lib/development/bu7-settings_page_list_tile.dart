//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:kar_kam/button_array.dart';

// Import project-specific files.
import 'package:kar_kam/clipped_rounded_rectangle_border.dart';
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/lib/global_key_extension.dart';

class SettingsPageListTile extends StatefulWidget {
  const SettingsPageListTile({Key? key}) : super(key: key);

  @override
  State<SettingsPageListTile> createState() => _SettingsPageListTileState();
}

class _SettingsPageListTileState extends State<SettingsPageListTile> {
  Rect? buttonArrayRect;

  @override
  void initState() {
    super.initState();

    //  Attempt to get buttonArrayGlobalKey (see base_page.dart) from
    //  buttonArrayGlobalKey and rebuild widget with setState.
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      GlobalKey buttonArrayGlobalKey = DataNotifier
          .of(context, ValueKey('buttonArrayGlobalKey')).data.value;
      setState(() {
        // print('_SettingsPageListTileState: initState: setting state...');
        buttonArrayRect = buttonArrayGlobalKey.globalPaintBounds;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //  Build widget. Result depends on whether buttonArrayRect is null or not.
    if (buttonArrayRect != null) {
      return ValueListenableBuilder<double>(
        valueListenable: DataNotifier
            .of(context, ValueKey('scrollController'))
            .data,
        builder: (BuildContext context, double value, __) {
          // print('_SettingsPageListTileState: build: buttonArrayRect = $buttonArrayRect');
          // print('_SettingsPageListTileState: build: value = $value');
          // print(value % 5 + 10);
          return Card(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(value % 50 + 10),
            // ),
            shape: ClippedRoundedRectangleBorder(
              context: context,
              side: BorderSide(width: 5.0, color: Colors.black, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10),
              guestRect: buttonArrayRect,
            ),
            elevation: 20,
            color: Colors.amber,
            child: ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text('SettingsPageListTile'),
              trailing: Icon(Icons.more_vert),
            ),
          );
          // return Card(
          //   child: ListTile(
          //     leading: FlutterLogo(size: 72.0),
          //     title: Text('SettingsPageListTile'),
          //     trailing: Icon(Icons.more_vert),
          //   ),
          // );
          //
      });
    } else {
      return Container();
    }
  }
}

// class SettingsPageListTile extends StatefulWidget {
//   const SettingsPageListTile({Key? key}) : super(key: key);
//
//   @override
//   State<SettingsPageListTile> createState() => _SettingsPageListTileState();
// }
//
// class _SettingsPageListTileState extends State<SettingsPageListTile> {
//   @override
//   Widget build(BuildContext context) {
//     print(DataNotifier.of(context, ValueKey('buttonArrayGlobalKey')).data.value);
//     print(DataNotifier.of(context, ValueKey('scrollController')).data.value);
//     return Container(child: Text('Test'),);
//   }
// }
