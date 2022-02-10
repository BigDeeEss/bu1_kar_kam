//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
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

  /// [buttonArrayRect] is instantiated with ButtonArray rect data using
  /// WidgetsBinding.instance!.addPostFrameCallback().
  late Rect buttonArrayRect;

  /// [butonArrayGlobalKey] allows rectgetter to be called from anywhere
  var butonArrayGlobalKey = RectGetter.createGlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageSpec.title),
      ),
      //  Use Builder widget because it is not possible to get the appBar
      //  height from the current BuildContext when it doesn't yet include the
      //  Scaffold class being returned by the parent widget.
      bottomNavigationBar: Builder(
        builder: (BuildContext context) {
          double appBarHeight =
              MediaQuery.of(context).padding.top + kToolbarHeight;

          return BottomAppBar(
            color: Colors.blue,
            child: SizedBox(
              //  Set height of the BottomAppBar class variable using
              //  SizedBox. Get height from [context] by first
              //  extracting the Scaffold that immediately wraps this
              //  widget, and then getting the value for appBarMaxHeight.
              height: appBarHeight * AppSettings.appBarHeightScaleFactor,
            ),
          );
        },
      ),
      //  Place page contents and ButtonArray on screen.
      //  Ensure that ButtonArray sits above the page content by placing
      //  it last in a Stack list of children.
      body: Stack(
        children: <Widget>[
          pageSpec.contents,
          RectGetter(
            key: butonArrayGlobalKey,
            child: ButtonArray(),
          ),
        ],
      ),
    );
  }
}
