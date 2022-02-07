//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/button_array.dart';
import 'package:kar_kam/page_specs.dart';

/// [BasePage] implements a generic page layout design so that a
/// similar UI is presented for each page/route.
class BasePage extends StatelessWidget {
  BasePage({
    Key? key,
    required this.pageSpec,
  }) : super(key: key);

  /// [pageSpec] defines the page content.
  final PageSpec pageSpec;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageSpec.title),
      ),
      //  Place page contents and ButtonArray; ensure  that ButtonArray sits
      //  above the page content by placing it last in a Stack list of children.
      body: Stack(
        children: <Widget>[
          pageSpec.contents,
          ButtonArray(),
        ],
      ),
    );
  }
}
