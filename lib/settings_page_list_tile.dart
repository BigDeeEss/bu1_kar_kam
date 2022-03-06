//  Import flutter packages.
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SettingsPageListTile extends StatefulWidget {
  const SettingsPageListTile({Key? key}) : super(key: key);

  @override
  State<SettingsPageListTile> createState() => _SettingsPageListTileState();
}

class _SettingsPageListTileState extends State<SettingsPageListTile> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {

    });

    return Card(
      child: testTile,
    );
  }
}

const testTile = ListTile(
  leading: FlutterLogo(size: 72.0),
  title: Text('Three-line ListTile'),
  subtitle: Text(
      'A sufficiently long subtitle warrants three lines.'
  ),
  trailing: Icon(Icons.more_vert),
  isThreeLine: true,
);