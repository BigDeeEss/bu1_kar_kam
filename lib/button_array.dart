//  Import dart and flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
// import 'package:kar_kam/animation_status_notification.dart';
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/button.dart';
import 'package:kar_kam/button_specs.dart';
import 'package:kar_kam/data_notification.dart';
import 'package:kar_kam/global_key_extension.dart';

/// [ButtonArray] implements a linear horizontal or vertical button array
/// in any of the four screen corners.
class ButtonArray extends StatelessWidget {
  ButtonArray({Key? key}) : super(key: key);

  /// [buttonSpecList] defines the specs for each button on the screen.
  static List<ButtonSpec> buttonSpecList = [
    settingsButton,
    filesButton,
    homeButton,
  ];

  /// [buttonListGlobalKey] is an array of GlobalKeys that enable Rect
  /// data from each button to be obtained using the GlobalKeyExtension
  /// method, globalPaintBounds.
  //
  //  The length of this list is determined by buttonSpecList via
  //  class method buttonList.
  final buttonListGlobalKey = <GlobalKey>[];

  /// [buttonList] generates a list of buttons from buttonSpecList.
  List<Widget> buttonList() {
    //  Initialise widgetList so that it is ready for population.
    List<Widget> widgetList = [];

    //  Loop over items in buttonSpecList and convert each to its
    //  corresponding button.
    for (int i = 0; i < buttonSpecList.length; i++) {
      buttonListGlobalKey.add(GlobalKey());

      //  Treat horizontal and vertical axes differently.
      if (AppSettings.buttonAxis == Axis.horizontal) {
        //  The top/bottom inputs to Positioned must be either 0.0/null,
        //  depending on whether selected alignment is top, or the reverse
        //  if bottom.
        //
        //  The left/right inputs to Positioned must be non-zero
        //  coordinates/null, depending on whether selected alignment is
        //  left, or the reverse if right.
        widgetList.add(Positioned(
          top: (AppSettings.buttonAlignment.y < 0) ? 0 : null,
          bottom: (AppSettings.buttonAlignment.y > 0) ? 0 : null,
          left: (AppSettings.buttonAlignment.x < 0)
              ? (AppSettings.buttonRadiusInner +
              AppSettings.buttonPaddingMainAxisExtra) * 2 * i
              : null,
          right: (AppSettings.buttonAlignment.x > 0)
              ? (AppSettings.buttonRadiusInner +
              AppSettings.buttonPaddingMainAxisExtra) * 2 * i
              : null,
          child: Button(
            buttonSpec: buttonSpecList[i],
            key: buttonListGlobalKey[i],
          ),
        ));
      }
      //  Treat horizontal and vertical axes differently.
      if (AppSettings.buttonAxis == Axis.vertical) {
        //  The left/right inputs to Positioned must be either 0.0/null,
        //  depending on whether selected alignment is left, or the reverse
        //  if right.
        //
        //  The top/bottom inputs to Positioned must be non-zero
        //  coordinates/null, depending on whether selected alignment is
        //  top, or the reverse if bottom.
        widgetList.add(Positioned(
          top: (AppSettings.buttonAlignment.y < 0)
              ? (AppSettings.buttonRadiusInner +
              AppSettings.buttonPaddingMainAxisExtra) * 2 * i
              : null,
          bottom: (AppSettings.buttonAlignment.y > 0)
              ? (AppSettings.buttonRadiusInner +
                  AppSettings.buttonPaddingMainAxisExtra) * 2 * i
              : null,
          left: (AppSettings.buttonAlignment.x < 0) ? 0.0 : null,
          right: (AppSettings.buttonAlignment.x > 0) ? 0.0 : null,
          child: Button(
            buttonSpec: buttonSpecList[i],
            key: buttonListGlobalKey[i],
          ),
        ));
      }
    }
    return widgetList;
  }

  Rect? getRect() {
    // Instantiate rect as null.
    Rect? rect = null;

    //  Loop over buttonListGlobalKey. buttonListGlobalKey has the same
    //  length as buttonSpecList.
    for (int i = 0; i < buttonListGlobalKey.length; i++) {
      //  Get Rect data for ith button.
      Rect? buttonRect = buttonListGlobalKey[i].globalPaintBounds;
      if (buttonRect != null) {
        //  If rect is null then overwrite with buttonRect, else expand
        //  rect to include buttonRect.
        (rect == null) ? rect = buttonRect
            : rect.expandToInclude(buttonRect);
      }
    }
    return rect;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Rect? buttonArrayRect = getRect();
      DataNotification(
        data: buttonArrayRect,
      ).dispatch(context);
    });
    //  Return a Stack with a list of children defined by buttonList.
    //  Output from buttonList is a list of buttons of length equal to
    //  buttonSpecList.length.
    return Stack(
      children: buttonList(),
    );
  }
}
