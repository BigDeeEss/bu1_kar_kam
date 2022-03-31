//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/lib/data_notifier.dart';

class SettingsPageListTileTwo extends StatefulWidget {
  const SettingsPageListTileTwo({Key? key}) : super(key: key);

  @override
  State<SettingsPageListTileTwo> createState() => _SettingsPageListTileTwoState();
}

class _SettingsPageListTileTwoState extends State<SettingsPageListTileTwo> {
  @override
  Widget build(BuildContext context) {
    //  Retrieve buttonArrayRect from instance of DataNotifier
    //  further up the widget tree.
    Rect buttonArrayRect = DataNotifier
        .of(context, ValueKey('buttonArrayRect')).data.value;

    return ValueListenableBuilder<double>(
      valueListenable: DataNotifier
          .of(context, ValueKey('scrollController')).data,
      builder: (BuildContext context, double value, __) {
        return ClipPath(
          child: Card(
            elevation: 20,
            color: Colors.amber,
            child: const ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text('SettingsPageListTile'),
              trailing: Icon(Icons.more_vert),
            ),
          );
        };
        return Container();
      },
    );
  }
}
