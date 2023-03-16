// Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

// Import project-specific files.
import 'package:kar_kam/base_page_view.dart';
import 'package:kar_kam/button_array.dart';
import 'package:kar_kam/lib/data_store.dart';
import 'package:kar_kam/page_specs.dart';
import 'package:kar_kam/settings.dart';
import 'package:kar_kam/settings_service.dart';

/// Implements a generic page layout design.
///
/// [BasePage] presents a similar UI for each page/route with:
///     1. an AppBar at the top with a title,
///     2. specific screen contents including buttons for navigation
///        and functionality, and
///     3. a bottom navigation bar.
class BasePage extends StatelessWidget with GetItMixin{
  BasePage({
    Key? key,
    required this.pageSpec,
  }) : super(key: key);

  /// Defines the page layout associated with each route.
  final PageSpec pageSpec;

  @override
  Widget build(BuildContext context) {
    // Watch for changes to SettingsService registered in GetIt.
    // This may or may not update the current value.
    Settings settings = watch<SettingsService, Settings>();

    // The [GlobalKey] required for calculating available screen dimensions.
    //
    // [basePageViewKey] is passed to [Stack] in order to get available
    // screen dimensions, and supplied to an instance of [DataStore] so that
    // widgets below this -- e.g. [SettingsPageContents] -- can calculate
    // screen dimensions.
    GlobalKey basePageViewKey = GlobalKey();

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
            child: SizedBox(
              // Set height of [BottomAppBar] using [SizedBox], [appBarHeight]
              // and [settings.appBarHeightScaleFactor].
              height: appBarHeight * settings.appBarHeightScaleFactor,
            ),
          );
        },
      ),
      // [Scaffold] body contents are placed within an instance of [DataStore]
      // in order to transfer [basePageViewKey] down the widget tree.
      //
      // [basePageViewKey] is used by widgets further down the widget tree to
      // get the available screen dimensions.
      //
      // [BasePageView] builds twice in succession, the first being an empty
      // screen and the second being valid [pageContents], so that the
      // available screen dimensions can be calculated and used by widgets
      // in the second phase.
      body: DataStore<GlobalKey>(
        key: const ValueKey('basePageViewKey'),
        data: basePageViewKey,
        child: BasePageView(
          key: basePageViewKey,
          pageContents: <Widget>[
            // pageSpec.contents,
            const BasePageViewTest(),
            ButtonArray(),
          ],
        ),
      ),
    );
  }
}

