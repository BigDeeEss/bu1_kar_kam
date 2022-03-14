//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/global_key_extension.dart';
import 'package:kar_kam/notification_notifier.dart';

class SettingsPageListTile extends StatefulWidget {
  const SettingsPageListTile({Key? key}) : super(key: key);

  @override
  _SettingsPageListTileState createState() => _SettingsPageListTileState();
}

class _SettingsPageListTileState extends State<SettingsPageListTile> {
  @override
  Widget build(BuildContext context) {
    return SettingsPageListTileChild(
      color: Colors.yellow,
    );
  }
}

class SettingsPageListTileChild extends StatefulWidget {
  SettingsPageListTileChild({
    Key? key,
    this.color,
    this.opacity,
    this.text,
  }) : super(key: key);

  final Color? color;
  final double? opacity;
  final String? text;

  @override
  State<SettingsPageListTileChild> createState() => SettingsPageListTileChildState();
}

class SettingsPageListTileChildState extends State<SettingsPageListTileChild> {
  final GlobalKey globalKey = GlobalKey();

  Rect? rect = null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      rect = globalKey.globalPaintBounds;
      print('initState, rect = $rect');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: NotificationNotifier.of <ScrollNotification, double> (context).notificationData,
      builder: (BuildContext context, double value, __,){
        print(value);
        print('BorderRadius.circular(value % 10 + 10) = ${value % 10 + 10}');
        return Card(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(value % 10 + 10),
            // borderRadius: BorderRadius.circular(15),
          ),
          elevation: value,
          key: globalKey,
          color: widget.color,
          child: ListTile(
            leading: FlutterLogo(size: 72.0),
            title: Text('SettingsPageListTileChild'),
            subtitle: Text(widget.text ?? ''),
            trailing: Icon(Icons.more_vert),
          ),
        );
      },
    );
    return Card(
      key: globalKey,
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text('SettingsPageListTileChild'),
        subtitle: Text(widget.text ?? ''),
        trailing: Icon(Icons.more_vert),
        tileColor: widget.color
      ),
    );
  }
}
