//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/button_array.dart';
import 'package:kar_kam/lib/data_notifier.dart';
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

  /// [buttonArrayGlobalKey] is made available to widgets below BasePage
  /// in the widget tree via [buttonArrayGlobalKeyNotifier] and an instance of
  /// DataNotifier.
  final GlobalKey buttonArrayGlobalKey = GlobalKey();

  /// [buttonArrayGlobalKeyNotifier], an instance of ValueNotifier<T>
  /// can be used to trigger rebuilds of widgets below BasePage in
  /// the widget tree
  late ValueNotifier<GlobalKey> buttonArrayGlobalKeyNotifier;

  @override
  Widget build(BuildContext context) {
    // Assign buttonArrayGlobalKey to buttonArrayGlobalKeyNotifier.
    buttonArrayGlobalKeyNotifier = ValueNotifier(buttonArrayGlobalKey);
    return Scaffold(
      appBar: AppBar(
        title: Text(pageSpec.title),
      ),
      //  Insert an instance of BottomAppBar.
      //  Use Builder widget because it is not possible to get the appBar
      //  height from the current BuildContext when it doesn't yet include
      //  information associated by the Scaffold class being built.
      bottomNavigationBar: Builder(
        builder: (BuildContext context) {
          double appBarHeight =
              MediaQuery.of(context).padding.top + kToolbarHeight;
          // This instance of Builder returns BottomAppBar.
          return BottomAppBar(
            color: Colors.blue,
            child: SizedBox(
              //  Set height of BottomAppBar using sizedBox. Get height from
              //  context by extracting the Scaffold that immediately wraps
              //  this widget, and then getting the value for appBarMaxHeight.
              height: appBarHeight * AppSettings.appBarHeightScaleFactor,
            ),
          );
        },
      ),
      //  The Scaffold body contents are placed within an instance of
      //  NotificationNotifier inorder to transfer [buttonArrayRectData]
      //  down to SettingsPageContents.
      body: DataNotifier(
        key: ValueKey('buttonArrayGlobalKey'),
        data: buttonArrayGlobalKeyNotifier,
        child: Stack(
          children: <Widget>[
            pageSpec.contents,
            ButtonArray(
              key: buttonArrayGlobalKey,
            ),
          ],
        ),
      ),
    );
  }
}
