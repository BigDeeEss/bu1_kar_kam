//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/clipped_rounded_rectangle_border.dart';
import 'package:kar_kam/lib/data_notifier.dart';

class SettingsPageListTile extends StatefulWidget {
  const SettingsPageListTile({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ScrollController controller;

  @override
  State<SettingsPageListTile> createState() => _SettingsPageListTileState();
}

class _SettingsPageListTileState extends State<SettingsPageListTile> {
  double scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (widget.controller.offset != scrollPosition) {
        print('_SettingsPageListTileState, scroll position = ${widget.controller.offset}');
        setState(() {
          scrollPosition = widget.controller.offset;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //  Retrieve buttonArrayRect from instance of DataNotifier
    //  further up the widget tree.
    Rect buttonArrayRect = DataNotifier
        .of(context, ValueKey('buttonArrayRect')).data.value;

    //  Contents of SettingsListTile.
    return Card(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(value % 50 + 10),
      // ),
      shape: ClippedRoundedRectangleBorder(
        pos: scrollPosition,
        context: context,
        side: BorderSide(width: 2.0, color: Colors.black, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10),
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
  }
}
