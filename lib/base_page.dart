// Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

// Import project-specific files.
import 'package:kar_kam/button_array.dart';
import 'package:kar_kam/lib/data_store.dart';
import 'package:kar_kam/lib/global_key_extension.dart';
import 'package:kar_kam/page_specs.dart';
import 'package:kar_kam/settings.dart';
import 'package:kar_kam/settings_page_list_tile.dart' show sf;
import 'package:kar_kam/settings_service.dart';

/// Implements a generic page layout design.
///
/// [BasePage] presents a similar UI for each page/route with:
///     1. an AppBar at the top with a title,
///     2. specific screen contents including buttons for navigation
///        and functionality, and
///     3. a bottom navigation bar.
///
/// [BasePage] is an extension of [StatefulWidget] because a combination of
/// [initState] and [WidgetsBinding.instance.addPostFrameCallback] is used for
/// getting [buttonArrayRect].
class BasePage extends StatefulWidget with GetItStatefulWidgetMixin {
  BasePage({
    Key? key,
    required this.pageSpec,
  }) : super(key: key);

  /// Defines the page layout associated with each route.
  final PageSpec pageSpec;

  @override
  State<BasePage> createState() => BasePageState();
}

class BasePageState extends State<BasePage> with GetItStateMixin {
  /// The [GlobalKey] required for calculating available screen dimensions.
  ///
  /// [basePageViewKey] is passed to [Stack] so that widgets below
  /// this -- e.g. [SettingsPageContents] -- can calculate screen dimensions.
  GlobalKey basePageViewKey = GlobalKey();

  /// The available screen dimensions.
  Rect? basePageViewRect = Rect.zero;

  /// Builds a linear horizontal or vertical array of buttons.
  ///
  /// [buttonArray] is referenced in the [build] and [initState] methods and
  /// so must be instantiated at the point of [BasePage] creation.
  final ButtonArray buttonArray = ButtonArray();

  /// The bounding box associated with [buttonArray].
  Rect? buttonArrayRect = Rect.zero;

  /// Specifies UI characteristics.
  ///
  /// [pageContents] (initially null) is updated by [setState] in a
  /// post-frame callback. [pageContents] may depend on knowledge of the
  /// existence of [buttonArray], and so therefore must be built at the end.
  ///
  /// An example is [SettingsPageContents] which requires [buttonArrayRect]
  /// to be known before it is built.
  Widget? pageContents;

  @override
  void initState() {
    // [BasePage] is built in two parts: (i) [buttonArray], by the [build]
    // function; and then (ii) [buttonArray] + [pageContents], initiated by
    // the following post-frame callback.
    //
    // [BasePage] is built in two parts because [pageContents] may require
    // [buttonArrayRect] -- e.g. [SettingsPageContents] -- to be known.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get [basePageView] [Rect] data and update [basePageViewRect].
      basePageViewRect = basePageViewKey.globalPaintBounds;

      // Get [buttonArray] [Rect] data and update [buttonArrayRect].
      buttonArrayRect = buttonArray.rect;

      // Rebuild widget with [pageSpec.contents] instead of [Container].
      if (pageContents == null) {
        setState(() {
          pageContents = widget.pageSpec.contents;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Watch for changes to SettingsService registered in GetIt.
    Settings settings = watch<SettingsService, Settings>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageSpec.title),
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
      // The [Scaffold] body contents are placed within two instances of
      // [DataStore] in order to transfer [buttonArrayRect] and
      // [basePageViewRect] down the widget tree.
      // ToDo: use one instance of DataSore instead of two.
      body: DataStore<Rect?>(
        key: const ValueKey('buttonArrayRect'),
        data: buttonArrayRect,
        child: DataStore<Rect?>(
          key: const ValueKey('basePageViewRect'),
          data: basePageViewRect,
          // Place page contents and [buttonArray] on screen using [Stack].
          //
          // Ensure that [buttonArray] sits above the page content by placing
          // it last in the associated list of children.
          //
          // If [pageContents] is null then put an empty [Container] into
          // [Stack], otherwise use its value (see ?? operator below).
          child: Stack(
            key: basePageViewKey,
            children: <Widget>[
              // To avoid errors place a temporary blank instance of [Container]
              // in place of [pageContents] whilst [buttonArrayRect] data is
              // obtained.
              pageContents ?? Container(),
              buttonArray,
              // Add two additional guidance circles for checking the sliding
              // motion of [SettingsPageListTile].
              // ToDo: delete these unnecessary guidance circles at some point.
              (settings.buttonAxis == Axis.horizontal)
                  ? Positioned(
                      top: (settings.buttonAlignment.y < 0) ? 0 : null,
                      bottom:
                          (settings.buttonAlignment.y > 0) ? 0 : null,
                      left: (settings.buttonAlignment.x < 0)
                          ? buttonArray.buttonCoordinates.first
                          : null,
                      right: (settings.buttonAlignment.x > 0)
                          ? buttonArray.buttonCoordinates.first
                          : null,
                      child: CustomPaint(
                        painter: OpenPainter(
                          alignment: settings.buttonAlignment,
                          axis: settings.buttonAxis,
                          radius: settings.buttonRadius + settings.buttonPaddingMainAxis,
                          shiftVal: (buttonArray.rect != null)
                              ? buttonArray.rect!.shortestSide * sf
                              : 0.0,
                        ),
                      ),
                    )
                  : Positioned(
                      top: (settings.buttonAlignment.y < 0)
                          ? buttonArray.buttonCoordinates.last
                          : null,
                      bottom: (settings.buttonAlignment.y > 0)
                          ? buttonArray.buttonCoordinates.last
                          : null,
                      left:
                          (settings.buttonAlignment.x < 0) ? 0.0 : null,
                      right:
                          (settings.buttonAlignment.x > 0) ? 0.0 : null,
                      child: CustomPaint(
                        painter: OpenPainter(
                          alignment: settings.buttonAlignment,
                          axis: settings.buttonAxis,
                          radius: settings.buttonRadius + settings.buttonPaddingMainAxis,
                          shiftVal: (buttonArray.rect != null)
                              ? buttonArray.rect!.shortestSide * sf
                              : 0.0,
                        ),
                      ),
                    ),
              (settings.buttonAxis == Axis.horizontal)
                  ? Positioned(
                      top: (settings.buttonAlignment.y < 0) ? 0 : null,
                      bottom:
                          (settings.buttonAlignment.y > 0) ? 0 : null,
                      left: (settings.buttonAlignment.x < 0)
                          ? buttonArray.buttonCoordinates.last
                          : null,
                      right: (settings.buttonAlignment.x > 0)
                          ? buttonArray.buttonCoordinates.last
                          : null,
                      child: CustomPaint(
                        painter: OpenPainter(
                          alignment: settings.buttonAlignment,
                          axis: settings.buttonAxis,
                          radius: settings.buttonRadius + settings.buttonPaddingMainAxis,
                          shiftVal: 0.0,
                        ),
                      ),
                    )
                  : Positioned(
                      top: (settings.buttonAlignment.y < 0)
                          ? buttonArray.buttonCoordinates.last
                          : null,
                      bottom: (settings.buttonAlignment.y > 0)
                          ? buttonArray.buttonCoordinates.last
                          : null,
                      left:
                          (settings.buttonAlignment.x < 0) ? 0.0 : null,
                      right:
                          (settings.buttonAlignment.x > 0) ? 0.0 : null,
                      child: CustomPaint(
                        painter: OpenPainter(
                          alignment: settings.buttonAlignment,
                          axis: settings.buttonAxis,
                          radius: settings.buttonRadius + settings.buttonPaddingMainAxis,
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

/// A custom painter for producing the guidance circles.
class OpenPainter extends CustomPainter{
  OpenPainter({
    required this.alignment,
    required this.axis,
    required this.radius,
    required this.shiftVal,
  });

  final Alignment alignment;

  final Axis axis;

  final double shiftVal;

  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    double r = radius;
    var paint1 = Paint()
      ..color = const Color.fromRGBO(66, 165, 245, 0.5)
      ..style = PaintingStyle.fill;
    if (axis == Axis.horizontal) {
      if (alignment.y < 0 && alignment.x > 0) {
        canvas.drawCircle(Offset(-r, r + shiftVal), r, paint1);
      }
      if (alignment.y < 0 && alignment.x < 0) {
        canvas.drawCircle(Offset(r, r + shiftVal), r, paint1);
      }
      if (alignment.y > 0 && alignment.x > 0) {
        canvas.drawCircle(Offset(-r, -r - shiftVal), r, paint1);
      }
      if (alignment.y > 0 && alignment.x < 0) {
        canvas.drawCircle(Offset(r, -r - shiftVal), r, paint1);
      }
    }
    if (axis == Axis.vertical) {
      if (alignment.y < 0 && alignment.x > 0) {
        canvas.drawCircle(Offset(-r, r + shiftVal), r, paint1);
      }
      if (alignment.y < 0 && alignment.x < 0) {
        canvas.drawCircle(Offset(r, r + shiftVal), r, paint1);
      }
      if (alignment.y > 0 && alignment.x > 0) {
        canvas.drawCircle(Offset(-r, -r - shiftVal), r, paint1);
      }
      if (alignment.y > 0 && alignment.x < 0) {
        canvas.drawCircle(Offset(r, -r - shiftVal), r, paint1);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
