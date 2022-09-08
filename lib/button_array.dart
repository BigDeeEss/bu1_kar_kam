//  Import dart and flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/button.dart';
import 'package:kar_kam/button_specs.dart';
import 'package:kar_kam/lib/global_key_extension.dart';

/// [ButtonArray] implements a linear horizontal or vertical button array.
class ButtonArray extends StatelessWidget {
  ButtonArray({Key? key}) : super(key: key);

  /// [buttonSpecList] defines the specs for each button on the screen.
  static List<ButtonSpec> buttonSpecList = [
    settingsButton,
    filesButton,
    homeButton,
  ];

  /// [buttonArrayGlobalKeys] is a list of GlobalKeys that enable Rect data
  /// for each button to be obtained using globalPaintBounds (see [getRect]).
  final buttonArrayGlobalKeys = <GlobalKey>[];

  /// [buttonCoords] gets coordinates relative to any corner.
  List<double> get buttonCoords {
    //  Initialise [coordsList] so that it is ready for population.
    List<double> coordsList = [];

    //  A length -- button width plus padding -- for defining [coordsList].
    // double dim = 2 * (AppSettings.buttonRadiusInner +
    //         AppSettings.buttonPaddingMainAxisExtra);
    double dim = 2 * (AppSettings.buttonRadiusInner +
            AppSettings.buttonPaddingMainAxis);

    //  Loop over items in [buttonSpecList] and convert each to its
    //  corresponding position.
    for (int i = 0; i < buttonSpecList.length; i++) {
      coordsList.add(dim * i);
    }
    return coordsList;
  }

  /// [rect] calculates the Rect data associated with [buttonArray].
  Rect? get rect {
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
    return rect;
  }

  /// [buttonArrayGenerator] generates a list of buttons from buttonSpecList.
  List<Widget> buttonArrayGenerator(BuildContext context) {
    //  Initialise [button] and [buttonList] ready for population.
    List<Widget> buttonList = [];

    //  Take a local copy of [buttonCoords] for speed.
    List<double> coords = buttonCoords;

    //  Loop over items in [buttonSpecList] and convert each to its
    //  corresponding button.
    for (int i = 0; i < buttonSpecList.length; i++) {
      buttonArrayGlobalKeys.add(GlobalKey());

      //  Define the button to be added to [buttonList] in this iteration.
      Button button = Button(
        buttonSpec: buttonSpecList[i],
        key: buttonArrayGlobalKeys[i],
      );

      //  Treat horizontal and vertical axes differently.
      if (AppSettings.buttonAxis == Axis.horizontal) {
        //  The top and bottom inputs to Positioned must be 0.0 or null,
        //  depending on whether the selected alignment is top or bottom.
        //
        //  The left and right inputs to Positioned must be non-zero
        //  coordinates or null, depending on whether the selected alignment is
        //  left or right.
        buttonList.add(Positioned(
          top: (AppSettings.buttonAlignment.y < 0) ? 0 : null,
          bottom: (AppSettings.buttonAlignment.y > 0) ? 0 : null,
          left: (AppSettings.buttonAlignment.x < 0) ? coords[i] : null,
          right: (AppSettings.buttonAlignment.x > 0) ? coords[i] : null,
          child: button,
        ));
      }

      //  Treat horizontal and vertical axes differently.
      if (AppSettings.buttonAxis == Axis.vertical) {
        //  The left and right inputs to Positioned must be 0.0 or null,
        //  depending on whether the selected alignment is left or right.
        //
        //  The top and bottom inputs to Positioned must be non-zero
        //  coordinates or null, depending on whether the selected alignment is
        //  top or bottom.
        buttonList.add(Positioned(
          top: (AppSettings.buttonAlignment.y < 0) ? coords[i] : null,
          bottom: (AppSettings.buttonAlignment.y > 0) ? coords[i] : null,
          left: (AppSettings.buttonAlignment.x < 0) ? 0.0 : null,
          right: (AppSettings.buttonAlignment.x > 0) ? 0.0 : null,
          child: button,
        ));
      }
    }
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    //  Generate the array of buttons.
    List<Widget> buttonArray = buttonArrayGenerator(context);

    //  Return an instance of Stack with its children defined to be a
    //  list of buttons. [buttonArray] is generated by [buttonArrayGenerator]
    //  and has length equal to buttonSpecList.length.
    return Stack(
      alignment: Alignment.bottomRight,
      children: buttonArray,
    );
  }
}
