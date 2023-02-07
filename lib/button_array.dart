//  Import dart and flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

// Import project-specific files.
import 'package:kar_kam/old_app_settings_data.dart';
import 'package:kar_kam/button.dart';
import 'package:kar_kam/button_specs.dart';
import 'package:kar_kam/lib/global_key_extension.dart';
import 'package:kar_kam/settings_service.dart';

/// Implements a linear horizontal or vertical array of Buttons.
class ButtonArray extends StatelessWidget with GetItMixin {
  ButtonArray({Key? key}) : super(key: key);

  /// [buttonSpecList] defines the specs for each button in [ButtonArray].
  static List<ButtonSpec> buttonSpecList = [
    settingsButton,
    filesButton,
    homeButton,
  ];

  /// [buttonArrayGlobalKeys] is a list of GlobalKeys that enable Rect data
  /// for each button to be obtained using globalPaintBounds (see [getRect]).
  final buttonArrayGlobalKeys = <GlobalKey>[];

  /// [buttonCoordinates] gets coordinates relative to any corner.
  List<double> get buttonCoordinates {
    //  Initialise [coordinateList] so that it is ready for population.
    List<double> coordinateList = [];

    //  A length -- button width plus padding -- for defining [coordinateList].
    //  Two different values for dim determine whether the bounding boxes
    //  for each Button overlap.
    double dim = 2 * (AppSettingsOrig.buttonRadius +
            AppSettingsOrig.buttonPaddingMainAxisAlt);

    //  Loop over items in [buttonSpecList] and convert each to its
    //  corresponding position.
    for (int i = 0; i < buttonSpecList.length; i++) {
      coordinateList.add(dim * i);
    }
    return coordinateList;
  }

  /// [rect] calculates the Rect data associated with [buttonArray].
  Rect? get rect {
    // Instantiate output variable as null initially.
    Rect? rect;

    //  Loop over [buttonArrayGlobalKeys]. [buttonArrayGlobalKeys] has the
    //  same length as buttonSpecList.
    for (int i = 0; i < buttonArrayGlobalKeys.length; i++) {
      //  Get Rect data for ith button.
      Rect? buttonRect = buttonArrayGlobalKeys[i].globalPaintBounds;

      //  Build rect by giving it [buttonRect] initially, and then expanding
      //  it by sequentially adding the Rect value for each button.
      if (buttonRect != null) {
        //  If rect is null then overwrite with [buttonRect], else expand
        //  rect to include [buttonRect].
        if (rect == null) {
          rect = buttonRect;
        } else {
          rect = rect.expandToInclude(buttonRect);
        }
      }
    }
    return rect;
  }

  /// [buttonArrayGenerator] generates a list of buttons from [buttonSpecList].
  List<Widget> buttonArrayGenerator(BuildContext context, Axis axis) {
    //  Initialise [buttonList] ready for population.
    List<Widget> buttonList = [];

    //  Take a local copy of [buttonCoordinates] for speed.
    List<double> coordinate = buttonCoordinates;

    //  Loop over items in [buttonSpecList] and convert each to its
    //  corresponding [button].
    for (int i = 0; i < buttonSpecList.length; i++) {
      buttonArrayGlobalKeys.add(GlobalKey());

      //  Define the [button] to be added to [buttonList] in this iteration.
      Button button = Button(
        buttonSpec: buttonSpecList[i],
        key: buttonArrayGlobalKeys[i],
      );

      //  Treat horizontal and vertical axes differently.
      if (axis == Axis.horizontal) {
        //  The top and bottom inputs to Positioned must be 0.0 or null,
        //  depending on whether the selected alignment is top or bottom.
        //
        //  The left and right inputs to Positioned must be non-zero
        //  coordinates or null, depending on whether the selected alignment
        //  is left or right.
        buttonList.add(Positioned(
          top: (AppSettingsOrig.buttonAlignment.y < 0) ? 0 : null,
          bottom: (AppSettingsOrig.buttonAlignment.y > 0) ? 0 : null,
          left: (AppSettingsOrig.buttonAlignment.x < 0) ? coordinate[i] : null,
          right: (AppSettingsOrig.buttonAlignment.x > 0) ? coordinate[i] : null,
          child: button,
        ));
      }

      //  Treat horizontal and vertical axes differently.
      if (axis == Axis.vertical) {
        //  The left and right inputs to Positioned must be 0.0 or null,
        //  depending on whether the selected alignment is left or right.
        //
        //  The top and bottom inputs to Positioned must be non-zero
        //  coordinates or null, depending on whether the selected alignment
        //  is top or bottom.
        buttonList.add(Positioned(
          top: (AppSettingsOrig.buttonAlignment.y < 0) ? coordinate[i] : null,
          bottom: (AppSettingsOrig.buttonAlignment.y > 0) ? coordinate[i] : null,
          left: (AppSettingsOrig.buttonAlignment.x < 0) ? 0.0 : null,
          right: (AppSettingsOrig.buttonAlignment.x > 0) ? 0.0 : null,
          child: button,
        ));
      }
    }
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    //  Watch for changes to SettingsService, specifically
    //  SettingsService.settingsData.buttonAxis.
    // bool drawLayoutBounds =
    //     watchOnly((SettingsService m) => m.settingsData.drawLayoutBounds);
    Axis buttonAxis = watchOnly((SettingsService m) => m.settingsData.buttonAxis);

    //  Generate the array of buttons.
    List<Widget> buttonArray = buttonArrayGenerator(context, buttonAxis);

    //  Return an instance of Stack with its children defined to be a
    //  list of buttons. [buttonArray] is generated by [buttonArrayGenerator]
    //  and has length equal to buttonSpecList.length.
    return Stack(
      alignment: Alignment.bottomRight,
      children: buttonArray,
    );
  }
}
