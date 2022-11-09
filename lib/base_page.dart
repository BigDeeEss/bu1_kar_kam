//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings_orig.dart';
import 'package:kar_kam/button_array.dart';
import 'package:kar_kam/lib/data_store.dart';
import 'package:kar_kam/lib/global_key_extension.dart';
import 'package:kar_kam/page_specs.dart';
import 'package:kar_kam/settings_page_list_tile.dart' show sf;

/// [BasePage] implements a generic page layout design.
///
/// [BasePage] presents a similar UI for each page/route with:
///     1. an AppBar at the top with a title,
///     2. specific screen contents including buttons for navigation
///        and functionality, and
///     3. a bottom navigation bar.
class BasePage extends StatefulWidget {
  const BasePage({
    Key? key,
    required this.pageSpec,
  }) : super(key: key);

  final PageSpec pageSpec;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  /// [basePageViewKey] stores the GlobalKey which is passed to Stack so that
  /// widgets below this -- e.g. SettingsPageContents -- are able to get
  /// the available screen dimensions.
  GlobalKey basePageViewKey = GlobalKey();

  /// [basePageViewRect] stores the available screen dimensions as Rect data.
  Rect? basePageViewRect = Rect.zero;

  /// [buttonArray] builds a linear horizontal or vertical array of buttons.
  ///
  /// [buttonArray] is referenced in the build and initState methods and
  /// so must be instantiated at the point of [BasePage] creation.
  final ButtonArray buttonArray = ButtonArray();

  /// [buttonArrayRect] stores Rect information associated with [buttonArray].
  Rect? buttonArrayRect = Rect.zero;

  /// [pageContents] (initially null) is updated by setState in a
  /// postFrameCallback.
  ///
  /// [pageContents] may depend on knowledge of the existence of [buttonArray].
  /// and so must be built after [buttonArray] in a post-frame callback.
  ///
  /// An example is SettingsPageContents which requires the Rect data
  /// associated with [buttonArray] to be known before it is built.
  Widget? pageContents;

  @override
  void initState() {
    super.initState();
    /// BasePage is built in two parts: (i) buttonArray, by the build
    /// function; and then (ii) buttonArray + pageContents, initiated by
    /// this post-frame callback.
    ///
    /// BasePage is built in two parts as pageContents may require
    /// the position of buttonArray -- see for example SettingsPageContents.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  Get basePageView Rect data and update basePageViewRect.
      basePageViewRect = basePageViewKey.globalPaintBounds;

      //  Get buttonArray Rect data and update buttonArrayRect.
      buttonArrayRect = buttonArray.rect;

      //  Rebuild widget with pageSpec.contents instead of Container().
      if (pageContents == null) {
        setState(() {
          pageContents = widget.pageSpec.contents;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageSpec.title),
      ),
      //  Use Builder widget to generate a BottomAppBar because it is not
      //  possible to get the appBar height from the current BuildContext since
      //  this instance of Scaffold hasn't been built yet.
      bottomNavigationBar: Builder(
        builder: (BuildContext context) {
          //  Get appBar height from context.
          double appBarHeight =
              MediaQuery.of(context).padding.top + kToolbarHeight;

          // This instance of Builder returns BottomAppBar.
          return BottomAppBar(
            color: Colors.blue,
            child: SizedBox(
              //  Set height of BottomAppBar using SizedBox, appBarHeight
              //  and AppSettings.appBarHeightScaleFactor.
              height: appBarHeight * AppSettingsOrig.appBarHeightScaleFactor,
            ),
          );
        },
      ),
      //  The Scaffold body contents are placed within two instances of
      //  DataNotifier in order to transfer buttonArrayRect and
      //  basePageViewRect down the widget tree.
      body: DataStore<Rect?>(
        key: const ValueKey('buttonArrayRect'),
        data: buttonArrayRect,
        child: DataStore<Rect?>(
          key: const ValueKey('basePageViewRect'),
          data: basePageViewRect,
          //  Place page contents and buttonArray on screen using Stack.
          //
          //  Ensure that buttonArray sits above the page content by placing
          //  it last in a Stack list of children.
          //
          //  If pageContents is null then put an empty container into Stack,
          //  otherwise use its value (see ?? operator below).
          //
          //  Note: pageContents equates to widget.pageSpec.contents.
          //  after setState.
          child: Stack(
            key: basePageViewKey,
            children: <Widget>[
              pageContents ?? Container(),
              buttonArray,
              //  Add two additional guidance circles for checking the sliding
              //  motion of SettingsPageListTile.
              (AppSettingsOrig.buttonAxis == Axis.horizontal)
                  ? Positioned(
                      top: (AppSettingsOrig.buttonAlignment.y < 0) ? 0 : null,
                      bottom: (AppSettingsOrig.buttonAlignment.y > 0) ? 0 : null,
                      left: (AppSettingsOrig.buttonAlignment.x < 0)
                          ? buttonArray.buttonCoords.first
                          : null,
                      right: (AppSettingsOrig.buttonAlignment.x > 0)
                          ? buttonArray.buttonCoords.first
                          : null,
                      child: CustomPaint(
                        painter: OpenPainter(
                          shiftVal: (buttonArray.rect != null)
                              ? buttonArray.rect!.shortestSide * sf
                              : 0.0,
                        ),
                      ),
                    )
                  : Positioned(
                      top: (AppSettingsOrig.buttonAlignment.y < 0)
                          ? buttonArray.buttonCoords.last
                          : null,
                      bottom: (AppSettingsOrig.buttonAlignment.y > 0)
                          ? buttonArray.buttonCoords.last
                          : null,
                      left: (AppSettingsOrig.buttonAlignment.x < 0) ? 0.0 : null,
                      right: (AppSettingsOrig.buttonAlignment.x > 0) ? 0.0 : null,
                      child: CustomPaint(
                        painter: OpenPainter(
                          shiftVal: (buttonArray.rect != null)
                              ? buttonArray.rect!.shortestSide * sf
                              : 0.0,
                        ),
                      ),
                    ),
              (AppSettingsOrig.buttonAxis == Axis.horizontal)
                  ? Positioned(
                      top: (AppSettingsOrig.buttonAlignment.y < 0) ? 0 : null,
                      bottom: (AppSettingsOrig.buttonAlignment.y > 0) ? 0 : null,
                      left: (AppSettingsOrig.buttonAlignment.x < 0)
                          ? buttonArray.buttonCoords.last
                          : null,
                      right: (AppSettingsOrig.buttonAlignment.x > 0)
                          ? buttonArray.buttonCoords.last
                          : null,
                      child: CustomPaint(
                        painter: OpenPainter(
                          shiftVal: 0.0,
                        ),
                      ),
                    )
                  : Positioned(
                      top: (AppSettingsOrig.buttonAlignment.y < 0)
                          ? buttonArray.buttonCoords.last
                          : null,
                      bottom: (AppSettingsOrig.buttonAlignment.y > 0)
                          ? buttonArray.buttonCoords.last
                          : null,
                      left: (AppSettingsOrig.buttonAlignment.x < 0) ? 0.0 : null,
                      right: (AppSettingsOrig.buttonAlignment.x > 0) ? 0.0 : null,
                      child: CustomPaint(
                        painter: OpenPainter(
                          shiftVal: 0.0,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

//  A custom painter for producing the guidance circles.
class OpenPainter extends CustomPainter {
  OpenPainter({
    required this.shiftVal,
  });

  final double shiftVal;

  double r = AppSettingsOrig.buttonRadius + AppSettingsOrig.buttonPaddingMainAxis;

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color.fromRGBO(66, 165, 245, 0.5)
      ..style = PaintingStyle.fill;
    if (AppSettingsOrig.buttonAxis == Axis.horizontal) {
      if (AppSettingsOrig.buttonAlignment.y < 0 &&
          AppSettingsOrig.buttonAlignment.x > 0) {
        canvas.drawCircle(Offset(-r, r + shiftVal), r, paint1);
      }
      if (AppSettingsOrig.buttonAlignment.y < 0 &&
          AppSettingsOrig.buttonAlignment.x < 0) {
        canvas.drawCircle(Offset(r, r + shiftVal), r, paint1);
      }
      if (AppSettingsOrig.buttonAlignment.y > 0 &&
          AppSettingsOrig.buttonAlignment.x > 0) {
        canvas.drawCircle(Offset(-r, -r - shiftVal), r, paint1);
      }
      if (AppSettingsOrig.buttonAlignment.y > 0 &&
          AppSettingsOrig.buttonAlignment.x < 0) {
        canvas.drawCircle(Offset(r, -r - shiftVal), r, paint1);
      }
    }
    if (AppSettingsOrig.buttonAxis == Axis.vertical) {
      if (AppSettingsOrig.buttonAlignment.y < 0 &&
          AppSettingsOrig.buttonAlignment.x > 0) {
        canvas.drawCircle(Offset(-r, r + shiftVal), r, paint1);
      }
      if (AppSettingsOrig.buttonAlignment.y < 0 &&
          AppSettingsOrig.buttonAlignment.x < 0) {
        canvas.drawCircle(Offset(r, r + shiftVal), r, paint1);
      }
      if (AppSettingsOrig.buttonAlignment.y > 0 &&
          AppSettingsOrig.buttonAlignment.x > 0) {
        canvas.drawCircle(Offset(-r, -r - shiftVal), r, paint1);
      }
      if (AppSettingsOrig.buttonAlignment.y > 0 &&
          AppSettingsOrig.buttonAlignment.x < 0) {
        canvas.drawCircle(Offset(r, -r - shiftVal), r, paint1);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
