//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/lib/global_key_extension.dart';

class SettingsPageListTile extends StatelessWidget {
  SettingsPageListTile({Key? key}) : super(key: key);

  // late GlobalKey? buttonArrayGlobalKey;
  // late Rect? buttonArrayRect;

  @override
  Widget build(BuildContext context) {
    Rect? buttonArrayRect;
    //  Attempt to get buttonArrayGlobalKey (see base_page.dart).
    GlobalKey buttonArrayGlobalKey = DataNotifier
        .of(context, ValueKey('buttonArrayGlobalKey')).data.value;
    // print(buttonArrayGlobalKey);
    // print(DataNotifier.of(context, ValueKey('scrollController')).data.value);
    print(DataNotifier.of(context, ValueKey('buttonArrayGlobalKey')).data);
    // Rect? buttonArrayRect = buttonArrayGlobalKey?.globalPaintBounds;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      buttonArrayRect = buttonArrayGlobalKey.globalPaintBounds;
      print(buttonArrayRect);
    });
    if (buttonArrayRect != null) {
      return ValueListenableBuilder<double>(
          valueListenable: DataNotifier
              .of(context, ValueKey('scrollController'))
              .data,
          builder: (BuildContext context, double value, __) {
            return Card();
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
