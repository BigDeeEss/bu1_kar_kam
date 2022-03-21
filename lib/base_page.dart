//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/button_array.dart';
import 'package:kar_kam/data_notification.dart';
import 'package:kar_kam/notification_notifier.dart';
import 'package:kar_kam/page_specs.dart';

/// [BasePage] implements a generic page layout design so that a
/// similar UI is presented for each page/route.
class BasePage extends StatefulWidget {
  BasePage({
    Key? key,
    required this.pageSpec,
  }) : super(key: key);

  /// [pageSpec] defines the page content.
  final PageSpec pageSpec;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  /// [buttonArrayRectData] stores Rect information that is dispatched as
  /// notifications by ButtonArray.
  final ValueNotifier<Rect?> buttonArrayRectData
      = ValueNotifier(Offset(0.0, 0.0) & Size(0.0, 0.0));

  /// [pageContents] (initially null) is updated by setState in a
  /// postFrameCallback.
  Widget? pageContents;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
              //  Set height of BottomAppBar using izedBox. Get height from
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
      body: NotificationNotifier<DataNotification, Rect?>(
        notificationData: buttonArrayRectData,
        onNotification: (notification) {
          if (notification is DataNotification) {
            buttonArrayRectData.value = notification.data;
          }
          return true;
        },
        //  Place page contents and ButtonArray on screen using Stack.
        //  Ensure that ButtonArray sits above the page content by placing
        //  it last in a Stack list of children.
        //
        //  If [pageContents] is null then post an empty container into Stack,
        //  otherwise use its value.
        //
        //  Note: [pageContents] equates to widget.pageSpec.contents
        //  after setState.
        child: Stack(
          children: <Widget>[
            pageContents ?? Container(),
            ButtonArray(key: buttonArrayGlobalKey),
          ],
        ),
      ),
    );
  }
}



final buttonArrayGlobalKey = GlobalKey();