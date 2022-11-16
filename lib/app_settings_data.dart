//  Import flutter packages.
import 'package:flutter/material.dart';

// // Import project-specific files.
// import 'package:kar_kam/lib/data_notification.dart';
//
// /// A notification that explicitly carries GlobalAppSettings data.
// class GlobalAppSettingsNotification extends LayoutChangedNotification {
//   GlobalAppSettingsNotification({
//     required this.data,
//   });
//
//   var data;
// }
//
// /// Dynamic storage of app settings data.
// class GlobalAppSettings extends StatefulWidget {
//   GlobalAppSettings({
//     required this.child,
//     Key? key,
//   }) : super(key: key);
//
//   final Widget child;
//
//   //  Set appSettings as default values or updates from storage.
//   AppSettingsOrig appSettings = AppSettingsOrig();
//
//   @override
//   State<GlobalAppSettings> createState() => _GlobalAppSettingsState();
// }
//
// class _GlobalAppSettingsState extends State<GlobalAppSettings> {
//   @override
//   Widget build(BuildContext context) {
//     //  This instance of NotificationNotifier catches new AppSettings
//     //  data that bubbles up from SettingsPageContents.
//     return NotificationListener<DataNotification>(
//       child: widget.child,
//       onNotification: (notification) {
//         print(notification.data);
//         setState(() {
//           widget.appSettings.drawLayoutBounds =
//               !widget.appSettings.drawLayoutBounds;
//         });
//         print('Test dispatch method...complete');
//         return false;
//       },
//     );
//   }
// }
//
/// Class container for all app settings.
class AppSettingsData {
  /// [appBarHeightScaleFactor] defines a simple scale factor to apply to
  /// appBar when calculating bottomNavigationBar height in BasePage class.
  double appBarHeightScaleFactor = 1.0;

  /// [buttonAlignment] defines the position of the anchor that determines
  /// button placement in ButtonArray class.
  // static Alignment buttonAlignment = Alignment.bottomLeft;
  // static Alignment buttonAlignment = Alignment.bottomRight;
  Alignment buttonAlignment = Alignment.topLeft;

  // static Alignment buttonAlignment = Alignment.topRight;

  /// [buttonAxis] sets the button axis type in ButtonArray.
  Axis buttonAxis = Axis.horizontal;

  // static Axis buttonAxis = Axis.vertical;

  /// [buttonPadding] defines the padding surrounding each button.
  EdgeInsetsDirectional get buttonPadding =>
      EdgeInsetsDirectional.all(buttonPaddingMainAxis);

  /// [buttonPaddingMainAxis] defines the main axis padding between buttons.
  double buttonPaddingMainAxis = 15.0;

  /// [buttonPaddingMainAxisAlt] defines an alternative main axis padding
  /// between buttons.
  double buttonPaddingMainAxisAlt = 12.5;

  /// [buttonRadius] defines the button radius in Button class.
  double buttonRadius = 28.0;

  /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
  ///
  /// Used for debugging widget screen location.
  bool drawLayoutBounds = true;

  /// [pageTransitionTime] defines the page transition time in milliseconds.
  int pageTransitionTime = 750;

  /// [settingsPageListTileFadeEffect] switches in/out the Text fade effect.
  bool settingsPageListTileFadeEffect = true;

  /// [settingsPageListTileIconSize] defines the icon radius.
  double settingsPageListTileIconSize = 25.0;

  /// [settingsPageListTilePadding] defines the padding between tiles.
  double settingsPageListTilePadding = 0.0;

  /// [settingsPageListTileRadius] defines the tile corner radius.
  double settingsPageListTileRadius = 15.0;

  /// Creates a copy of the current instance of [AppSettingsData].
  AppSettingsData copy() {
    AppSettingsData data = AppSettingsData();

    //  Copy over data, element by element.
    data.appBarHeightScaleFactor = appBarHeightScaleFactor;
    data.buttonAlignment = buttonAlignment;
    data.buttonAxis = buttonAxis;
    data.appBarHeightScaleFactor = appBarHeightScaleFactor;
    data.buttonPaddingMainAxis = buttonPaddingMainAxis;
    data.buttonPaddingMainAxisAlt = buttonPaddingMainAxisAlt;
    data.buttonRadius = buttonRadius;
    data.drawLayoutBounds = drawLayoutBounds;
    data.pageTransitionTime = pageTransitionTime;
    data.settingsPageListTileFadeEffect = settingsPageListTileFadeEffect;
    data.settingsPageListTileIconSize = settingsPageListTileIconSize;
    data.settingsPageListTilePadding = settingsPageListTilePadding;
    data.settingsPageListTileRadius = settingsPageListTileRadius;

    return data;
  }
}
