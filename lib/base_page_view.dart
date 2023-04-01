// Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/lib/data_store.dart';
import 'package:kar_kam/lib/get_it_service.dart';
import 'package:kar_kam/lib/global_key_extension.dart';
import 'package:kar_kam/settings.dart';

/// Is a wrapper for an instance of [DataStore] and [_BasePageView].
class BasePageView extends StatelessWidget {
  const BasePageView({
    Key? key,
    required this.pageContents,
  }) : super(key: key);

  /// A list of widgets to build on the screen.
  final List<Widget> pageContents;

  @override
  Widget build(BuildContext context) {
    GlobalKey basePageViewKey = GlobalKey();

    return DataStore<GlobalKey>(
      key: const ValueKey('basePageViewKey'),
      data: basePageViewKey,
      child: _BasePageView(
        key: basePageViewKey,
        pageContents: pageContents,
      ),
    );
  }
}

/// Builds [pageContents] in two parts in order to offer a way for widgets
/// further down the widget tree to get the available screen dimensions
/// via the required key and [globalPaintBounds].
class _BasePageView extends StatefulWidget {
  const _BasePageView({
    required Key key,
    required this.pageContents,
  }) : super(key: key);

  /// A list of widgets to build on the screen.
  final List<Widget> pageContents;

  @override
  State<_BasePageView> createState() => _BasePageViewState();
}

class _BasePageViewState extends State<_BasePageView> {
  /// [pageContents] is updated by [setState] in a post-frame callback.
  ///
  /// [pageContents] may depend on knowledge of the [Rect] that defines the
  /// bounding box for [_BasePageView], hence the reason for the two-part build.
  List<Widget>? pageContents;

  @override
  void initState() {
    // [_BasePageView] is built in two phases:
    //    (i) with [pageContents] = [Container()], by the [build] method;
    //    and then
    //    (ii) with [pageContents] = [widget.pageContents], initiated by
    //    the following post-frame callback.
    //
    // [_BasePageView] is built in two phases because [pageContents] may require
    // knowledge of the available screen dimensions which this widget attempts
    // to provide.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get [basePageViewKey] (from [DataStore] in [BasePageView]),
      // calculate [basePageViewRect] and upload to the registered instance of
      // SettingsService in GetIt.
      GlobalKey basePageViewKey =
          DataStore.of<GlobalKey>(context, const ValueKey('basePageViewKey'))
              .data;
      Rect? basePageViewRect = basePageViewKey.globalPaintBounds;

      // Check and upload basePageViewRect to the instance of [Settings]
      // registered with [GetItService].
      assert(basePageViewRect != null,
          '_BasePageViewState, initState...error, basePageViewRect is null...');
      GetItService.instance<Settings>().change(
        identifier: 'basePageViewRect',
        newValue: basePageViewRect,
        notify: false,
      );

      // Update the [buttonArrayRect] in the instance of [Settings]
      // registered with GetIt.
      // The class method [updateButtonArrayRect] generates the bounding box
      // for [ButtonArray].
      // Call [updateButtonArrayRect] as soon as [basePageViewRect] is known.
      GetItService.instance<Settings>().buttonArrayRect =
          GetItService.instance<Settings>().updateButtonArrayRect();

      // Rebuild widget with [pageSpec.contents] instead of [Container].
      if (pageContents == null) {
        setState(() {
          pageContents = widget.pageContents;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: pageContents ?? [Container()],
    );
  }
}

/// Tests whether [basePageViewRect] can be calculated using the
class BasePageViewTest extends StatelessWidget {
  const BasePageViewTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get [basePageViewRect] (from [DataStore] in [BasePage]).
    GlobalKey basePageViewKey =
        DataStore.of<GlobalKey>(context, const ValueKey('basePageViewKey'))
            .data;
    Rect? basePageViewRect = basePageViewKey.globalPaintBounds;

    assert(basePageViewRect != null,
        'BasePageViewTest, build...basePageViewRect is null...');

    // Print basePageViewRect for test purposes and return [Placeholder]..
    print('BasePageViewTest, build...basePageViewRect = $basePageViewRect...');
    return const Placeholder();
  }
}
