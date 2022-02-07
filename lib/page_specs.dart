//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.

class PageSpec {
  /// Class for ease of reference to specific page settings.
  const PageSpec({
    required this.title,
    required this.contents,
  });

  /// Page [title].
  final String title;

  /// Page [contents].
  final Widget contents;
}

//  Home page specs.
PageSpec homePage = PageSpec(
  title: 'Home',
  contents: Container(),
);

//  Home page specs.
PageSpec filesPage = PageSpec(
  title: 'Files',
  contents: Container(),
);

//  Home page specs.
PageSpec settingsPage = PageSpec(
  title: 'Settings',
  contents: Container(),
);