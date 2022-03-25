//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:kar_kam/lib/data_notifier.dart';

class SettingsPageListTile extends StatefulWidget {
  const SettingsPageListTile({Key? key}) : super(key: key);

  @override
  State<SettingsPageListTile> createState() => _SettingsPageListTileState();
}

class _SettingsPageListTileState extends State<SettingsPageListTile> {
  @override
  Widget build(BuildContext context) {
    print(DataNotifier.of(context, ValueKey('buttonArrayGlobalKey')).data.value);
    print(DataNotifier.of(context, ValueKey('scrollController')).data.value);
    return Container(child: Text('Test'),);
  }
}
