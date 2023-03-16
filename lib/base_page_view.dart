// Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/lib/data_store.dart';
import 'package:kar_kam/lib/global_key_extension.dart';

/// Builds [pageContents] in two parts in order to offer a way for widgets
/// further down the widget tree to get the available screen dimensions
/// via the required key and [globalPaintBounds]..
class BasePageView extends StatefulWidget {
  const BasePageView({
    required Key key,
    required this.pageContents,
  }) : super(key: key);

  /// A list of widgets to build on the screen.
  final List<Widget> pageContents;

  @override
  State<BasePageView> createState() => _BasePageViewState();
}

class _BasePageViewState extends State<BasePageView> {
  /// [pageContents] is updated by [setState] in a post-frame callback.
  ///
  /// [pageContents] may depend on knowledge of the [Rect] that defines the
  /// bounding box for [BasePageView], hence the reason for the two-part build.
  List<Widget>? pageContents;

  @override
  void initState() {
    // [BasePageView] is built in two phases:
    //    (i) with [pageContents] = [Container()], by the [build] method;
    //    and then
    //    (ii) with [pageContents] = [widget.pageContents], initiated by
    //    the following post-frame callback.
    //
    // [BasePageView] is built in two phases because [pageContents] may require
    // knowledge of the available screen dimensions which this widget attempts
    // to provide.
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

    // Print [basePageViewRect].
    assert(basePageViewRect != null,
        'BasePageViewTest, build...basePageViewRect is null...');
    print('BasePageViewTest, build...basePageViewRect = $basePageViewRect...');

    return const Placeholder();
  }
}
