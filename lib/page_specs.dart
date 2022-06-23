//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/list_view_builder_settings_page_contents.dart';

/// [PageSpec] allows for ease of reference to specific page settings.
class PageSpec {
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

//  Settings Home page specs.
PageSpec settingsPage = PageSpec(
  title: 'Settings',
  contents: ListViewBuilderSettingsPageContents(),
);