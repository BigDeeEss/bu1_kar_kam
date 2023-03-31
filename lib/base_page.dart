// Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

// Import project-specific files.
import 'package:kar_kam/base_page_view.dart';
import 'package:kar_kam/button_array.dart';
import 'package:kar_kam/lib/global_key_extension.dart';
import 'package:kar_kam/page_specs.dart';
import 'package:kar_kam/settings.dart';
import 'package:kar_kam/sliding_guides.dart';

/// Implements a generic page layout design.
///
/// [BasePage] presents a similar UI for each page with:
///     1. an AppBar at the top with a title,
///     2. specific screen contents including buttons for navigation
///        and functionality, and
///     3. a bottom navigation bar.
class BasePage extends StatefulWidget with GetItStatefulWidgetMixin {
  BasePage({
    Key? key,
    required this.pageSpec,
  }) : super(key: key);

  /// Defines the page layout.
  final PageSpec pageSpec;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> with GetItStateMixin {
  GlobalKey appBarKey = GlobalKey();

  Rect? appBarRect;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Rect? rect = appBarKey.globalPaintBounds;

      print('_BasePageState, initState...appBarRect = $appBarRect');

      assert(rect != null, '_BasePageState, initState...error, appBarRect is null...');
      setState(() {
        appBarRect = rect;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Watch for changes to [appBarHeightScaleFactor] in the instance of
    // [Settings] registered with GetIt.
    double appBarHeightScaleFactor =
        watchOnly((Settings s) => s.appBarHeightScaleFactor);

    print('_BasePageState, build...appBarRect = $appBarRect');
    return Scaffold(
      appBar: AppBar(
        key: appBarKey,
        title: Text(widget.pageSpec.title),
      ),
      // Use [Builder] widget to generate a [BottomAppBar].
      //
      // It is not possible to get the appBar height from [context] since
      // this instance of [Scaffold] hasn't been built yet.
      // Effectively this introduces another layer.
      bottomNavigationBar: (appBarRect != null) ? BottomAppBar(
            color: Colors.blue,
            height: appBarRect!.height * appBarHeightScaleFactor,
          ) : null,

      // Builder(
      //   builder: (BuildContext context) {
      //     return
      //       BottomAppBar(
      //       color: Colors.blue,
      //       height: appBarRect!.height * appBarHeightScaleFactor,
      //     );
      //   },
      // ) : null,
      // [Scaffold] body is passed to an instance of [BasePageView] as this
      // widget uploads the available screen dimensions to [Settings].
      body: BasePageView(
        pageContents: <Widget>[
          widget.pageSpec.contents,
          SlidingGuides(),
          ButtonArray(),
        ],
      ),
    );
  }
}
