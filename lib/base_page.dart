// Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

// Import project-specific files.
import 'package:kar_kam/base_page_view.dart';
import 'package:kar_kam/button_array.dart';
import 'package:kar_kam/page_specs.dart';
import 'package:kar_kam/settings.dart';
import 'package:kar_kam/settings_service.dart';
import 'package:kar_kam/sliding_guides.dart';

/// Implements a generic page layout design.
///
/// [BasePage] presents a similar UI for each page/route with:
///     1. an AppBar at the top with a title,
///     2. specific screen contents including buttons for navigation
///        and functionality, and
///     3. a bottom navigation bar.
class BasePage extends StatelessWidget with GetItMixin {
  BasePage({
    Key? key,
    required this.pageSpec,
  }) : super(key: key);

  /// Defines the page layout associated with each route.
  final PageSpec pageSpec;

  @override
  Widget build(BuildContext context) {
    // Watch for changes to [Settings.drawLayoutBounds] registered with GetIt.
    double appBarHeightScaleFactor =
        watchOnly((Settings s) => s.appBarHeightScaleFactor);

    return Scaffold(
      appBar: AppBar(
        title: Text(pageSpec.title),
      ),
      // Use [Builder] widget to generate a [BottomAppBar].
      //
      // It is not possible to get the appBar height from [context] since
      // this instance of [Scaffold] hasn't been built yet.
      bottomNavigationBar: Builder(
        builder: (BuildContext context) {
          // Get appBar height from context.
          double appBarHeight =
              MediaQuery.of(context).padding.top + kToolbarHeight;

          return BottomAppBar(
            color: Colors.blue,
            height: appBarHeight * appBarHeightScaleFactor,
          );
        },
      ),
      // [Scaffold] body is passed to an instance of [BasePageView] as this
      // widget uploads the available screen dimensions to [Settings].
      body: BasePageView(
        pageContents: <Widget>[
          pageSpec.contents,
          SlidingGuides(),
          ButtonArray(),
        ],
      ),
    );
  }
}
