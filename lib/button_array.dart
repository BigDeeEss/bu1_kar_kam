//  Import dart and flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/button.dart';
import 'package:kar_kam/button_specs.dart';
import 'package:kar_kam/lib/data_notification.dart';
import 'package:kar_kam/lib/global_key_extension.dart';

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

  /// [buttonArrayGlobalKeys] is an array of GlobalKeys that enable Rect data
  /// from each button to be obtained using the GlobalKeyExtension method,
  /// globalPaintBounds. This feature is implemented below in [getRect].
  //
  //  The length of this list is determined by [buttonSpecList] via
  //  class method [buttonArrayGenerator].
  final buttonArrayGlobalKeys = <GlobalKey>[];

  /// [buttonArrayGenerator] generates a list of buttons from buttonSpecList.
  List<Widget> buttonArrayGenerator() {
    //  Initialise widgetList so that it is ready for population.
    List<Widget> widgetList = [];

    //  Loop over items in [buttonSpecList] and convert each to its
    //  corresponding button.
    for (int i = 0; i < buttonSpecList.length; i++) {
      buttonArrayGlobalKeys.add(GlobalKey());

      //  Treat horizontal and vertical axes differently.
      if (AppSettings.buttonAxis == Axis.horizontal) {
        //  The top/bottom inputs to Positioned must be either 0.0/null,
        //  depending on whether selected alignment is top or bottom, in which
        //  case it is the reverse configuration.
        //
        //  The left/right inputs to Positioned must be non-zero
        //  coordinates/null, depending on whether selected alignment is
        //  left or right, in which case it is the reverse configuration.
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
            key: buttonArrayGlobalKeys[i],
          ),
        ));
      }

      //  Treat horizontal and vertical axes differently.
      if (AppSettings.buttonAxis == Axis.vertical) {
        //  The left/right inputs to Positioned must be either 0.0/null,
        //  depending on whether selected alignment is left or right, in which
        //  case it is the reverse configuration.
        //
        //  The top/bottom inputs to Positioned must be non-zero
        //  coordinates/null, depending on whether selected alignment is
        //  top or bottom, in which case it is the reverse configuration.
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
            key: buttonArrayGlobalKeys[i],
          ),
        ));
      }
    }
    return widgetList;
  }

  Rect getRect() {
    // Instantiate output variable as null initially.
    Rect? rect;

    //  Loop over [buttonArrayGlobalKeys]. [buttonArrayGlobalKeys] has the
    //  same length as [buttonSpecList].
    for (int i = 0; i < buttonArrayGlobalKeys.length; i++) {
      //  Get Rect data for ith button.
      Rect? buttonRect = buttonArrayGlobalKeys[i].globalPaintBounds;

      //  Build [rect] by giving it buttonRect initially, and then expanding
      //  it by sequentially adding the Rect value for each button.
      if (buttonRect != null) {
        //  If rect is null then overwrite with buttonRect, else expand
        //  rect to include buttonRect.
        if (rect == null) {
          rect = buttonRect;
        } else {
          rect = rect.expandToInclude(buttonRect);
        }
      }
    }
    assert(rect != null,
      'button_array.dart, getRect: error rect is null when it shouldn\'t be.'
    );
    return rect!;
  }

  @override
  Widget build(BuildContext context) {
    //  Generate the array of buttons.
    List<Widget> buttonArray = buttonArrayGenerator();

    //  Return an instance of Stack with its children defined to be a
    //  list of buttons. [buttonArray] is generated by [buttonArrayGenerator]
    //  and has length equal to buttonSpecList.length.
    return Stack(
      children: buttonArray,
    );
  }
}
