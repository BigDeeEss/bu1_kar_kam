//  Import flutter packages.
import 'package:flutter/material.dart';
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
          return Card(
            child: ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text('SettingsPageListTile'),
              trailing: Icon(Icons.more_vert),
            ),);
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
