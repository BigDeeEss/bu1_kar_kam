// Import dart and flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

// Import project-specific files.
import 'package:kar_kam/button.dart';
import 'package:kar_kam/button_specs.dart';
import 'package:kar_kam/lib/get_it_service.dart';
import 'package:kar_kam/lib/global_key_extension.dart';
import 'package:kar_kam/settings.dart';
import 'package:kar_kam/settings_service.dart';

/// Implements a linear horizontal or vertical array of Buttons.
//
// Need to override the @immutable feature of [StatelessWidget] due to
// [settings] being initialised and then potentially overwritten in [build].
// ignore: must_be_immutable
class ButtonArray extends StatelessWidget with GetItMixin {
  ButtonArray({Key? key}) : super(key: key);

  /// For obtaining [Rect] for each button using [globalPaintBounds].
  final buttonArrayGlobalKeys = <GlobalKey>[];

  /// Specs for each button in [ButtonArray].
  final List<ButtonSpec> buttonSpecList = [
    settingsButton,
    filesButton,
    homeButton,
  ];

  /// A current copy of app settings that may be updated during [build].
  Settings settings = GetItService.instance<SettingsService>().value;

  /// Generates a list of coordinates relative to any corner.
  List<double> get buttonCoordinates {
    // Initialise [coordinateList] so that it is ready for population.
    List<double> coordinateList = [];

    // A length -- button width plus padding -- for defining [coordinateList].
    // Using two parameters allows for the bounding boxes of buttons to overlap.
    double dim =
        2 * (settings.buttonRadius + settings.buttonPaddingMainAxisAlt);

    // Loop over items in [buttonSpecList] and convert each to its
    // corresponding position.
    for (int i = 0; i < buttonSpecList.length; i++) {
      coordinateList.add(dim * i);
    }
    return coordinateList;
  }

  /// [rect] calculates the [Rect] data associated with [buttonArray].
  Rect? get rect {
    // Instantiate output variable as null initially.
    Rect? rect;

    //  Loop over [buttonArrayGlobalKeys], equivalent to the number of buttons.
    for (int i = 0; i < buttonArrayGlobalKeys.length; i++) {
      //  Get [Rect] data for the ith button.
      Rect? buttonRect = buttonArrayGlobalKeys[i].globalPaintBounds;

      //  Build rect by giving it [buttonRect] initially, and then expanding
      //  it by sequentially adding the [Rect] value for each button.
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

  /// Generates a list of buttons from [buttonSpecList].
  List<Widget> buttonArrayGenerator(BuildContext context) {
    //  Initialise [buttonList] ready for population.
    List<Widget> buttonList = [];

    //  Take a local copy of [buttonCoordinates] for speed.
    List<double> coordinates = buttonCoordinates;

    //  Loop over items in [buttonSpecList] and convert each to its
    //  corresponding [button].
    for (int i = 0; i < buttonSpecList.length; i++) {
      buttonArrayGlobalKeys.add(GlobalKey());

      //  Defines the [button] to be added to [buttonList] in this iteration.
      Button button = Button(
        buttonSpec: buttonSpecList[i],
        key: buttonArrayGlobalKeys[i],
      );

      //  Treat horizontal and vertical axes differently.
      if (settings.buttonAxis == Axis.horizontal) {
        //  The top and bottom inputs to Positioned must be 0.0 or null,
        //  depending on whether the selected alignment is top or bottom.
        //
        //  The left and right inputs to Positioned must be non-zero
        //  coordinates or null, depending on whether the selected alignment
        //  is left or right.
        buttonList.add(Positioned(
          top: (settings.buttonAlignment.y < 0) ? 0 : null,
          bottom: (settings.buttonAlignment.y > 0) ? 0 : null,
          left: (settings.buttonAlignment.x < 0) ? coordinates[i] : null,
          right: (settings.buttonAlignment.x > 0) ? coordinates[i] : null,
          child: button,
        ));
      }

      //  Treat horizontal and vertical axes differently.
      if (settings.buttonAxis == Axis.vertical) {
        //  The left and right inputs to Positioned must be 0.0 or null,
        //  depending on whether the selected alignment is left or right.
        //
        //  The top and bottom inputs to Positioned must be non-zero
        //  coordinates or null, depending on whether the selected alignment
        //  is top or bottom.
        buttonList.add(Positioned(
          top: (settings.buttonAlignment.y < 0) ? coordinates[i] : null,
          bottom: (settings.buttonAlignment.y > 0) ? coordinates[i] : null,
          left: (settings.buttonAlignment.x < 0) ? 0.0 : null,
          right: (settings.buttonAlignment.x > 0) ? 0.0 : null,
          child: button,
        ));
      }
    }
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    // Watch for changes to [SettingsService] registered in [GetIt].
    settings = watch<SettingsService, Settings>();

    // Generate the array of buttons.
    List<Widget> buttonArray = buttonArrayGenerator(context);

    // Return an instance of [Stack] with its children defined to be a
    // list of buttons. [buttonArray] is generated by [buttonArrayGenerator]
    // and has length equal to buttonSpecList.length.
    return Stack(
      // alignment: Alignment.bottomRight,
      children: buttonArray,
    );
  }
}
