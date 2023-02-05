//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/settings_page_contents.dart';

class PageSpec extends StatelessWidget {
  const PageSpec({
    Key? key,
    required this.contents,
    required this.title,
  }) : super(key: key);

  /// The [contents] associated with each page/route.
  final Widget contents;

  /// The [title] associated with each page/route.
  final String title;

  @override
  Widget build(BuildContext context) {
    return const contents;
  }
}


/// [PageSpecOld] allows for ease of reference to specific page settings.
class PageSpecOld {
  const PageSpecOld({
    required this.title,
    required this.contents,
  });

  /// The [title] associated with each page/route.
  final String title;

  /// The [contents] associated with each page/route.
  final Widget contents;
}

/// Home page specs.
PageSpecOld homePage = PageSpecOld(
  title: 'Home',
  contents: Container(),
);

/// Files page specs.
PageSpecOld filesPage = PageSpecOld(
  title: 'Files',
  contents: Container(),
);

/// Settings page specs.
PageSpecOld settingsPage = const PageSpecOld(
  title: 'Settings',
  contents: SettingsPageContents(),
);