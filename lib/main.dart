//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/base_page.dart';
import 'package:kar_kam/page_specs.dart';

//  App start point.
void main() {
  runApp(const _KarKam());
}

/// [_KarKam] is the root widget of this project.
class _KarKam extends StatelessWidget {
  const _KarKam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '_KarKam',

      //  BasePage invokes a generic page layout: a similar UI is
      //  presented for each page(route).
      home: Container(),
      // home: BasePage(
      //   pageSpec: settingsPage,
      // ),
    );
  }
}
