//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:kar_kam/lib/data_notifier.dart';
import 'package:kar_kam/lib/global_key_extension.dart';

class SettingsPageListTile extends StatelessWidget {
  const SettingsPageListTile({Key? key}) : super(key: key);

  final GlobalKey? buttonArrayGlobalKey;
  final Rect? buttonArrayRect;

  @override
  Widget build(BuildContext context) {
    GlobalKey? buttonArrayGlobalKey = DataNotifier
        .of(context, ValueKey('buttonArrayGlobalKey')).data.value;
    Rect? buttonArrayRect = buttonArrayGlobalKey?.globalPaintBounds;
    // print(buttonArrayGlobalKey);
    // print(DataNotifier.of(context, ValueKey('buttonArrayGlobalKey')).data.value);
    // print(DataNotifier.of(context, ValueKey('scrollController')).data.value);
    return ValueListenableBuilder<double>(
      valueListenable: DataNotifier
          .of(context, ValueKey('scrollController')).data,
      builder: (BuildContext context, double value, __) {
        return Card();
      });
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
