// Import dart and flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

// Import project-specific files.
import 'package:kar_kam/button.dart';
import 'package:kar_kam/lib/data_store.dart';
import 'package:kar_kam/lib/get_it_service.dart';
import 'package:kar_kam/lib/global_key_extension.dart';
import 'package:kar_kam/lib/rect_extension.dart';
import 'package:kar_kam/settings.dart';
import 'package:kar_kam/settings_service.dart';

/// Implements a linear horizontal or vertical array of Buttons.
//
// Need to override the @immutable feature of [StatelessWidget] due to
// [settings] being initialised and then potentially overwritten in [build].
// ignore: must_be_immutable
class ButtonArray extends StatelessWidget with GetItMixin {
  ButtonArray({Key? key}) : super(key: key);

  /// Generates a list of coordinates relative to any corner.
  static List<double> get buttonCoordinates {
    // Get a current copy of app settings.
    Settings settings = GetItService.instance<SettingsService>().value;

    // A length -- button width plus padding -- for defining [coordinateList].
    // Using two parameters allows for the bounding boxes of buttons to overlap.
    double dim =
        2 * (settings.buttonRadius + settings.buttonPaddingMainAxisAlt);

    // Loop over items in [settings.buttonSpecList] and convert each to its
    // corresponding position.
    List<double> coordinateList = [];
    for (int i = 0; i < settings.buttonSpecList.length; i++) {
      coordinateList.add(dim * i);
    }
    return coordinateList;
  }

  /// Calculates the [Rect] data associated with [buttonArray].
  static Rect rect(BuildContext context) {
    // Get available screen dimensions.
    GlobalKey basePageViewKey =
        DataStore.of<GlobalKey>(context, const ValueKey('basePageViewKey'))
            .data;
    Rect? basePageViewRect = basePageViewKey.globalPaintBounds;

    // Get a current copy of app settings.
    Settings settings = GetItService.instance<SettingsService>().value;

    double dim =
        2 * (settings.buttonRadius + settings.buttonPaddingMainAxisAlt);
    double shortLength =
        2.0 * (settings.buttonRadius + settings.buttonPaddingMainAxis);
    double longLength =
        (settings.buttonSpecList.length - 1) * dim + shortLength;

    // Generate Rect of the correct size at screen top left.
    Rect rect = Rect.zero;
    if (settings.buttonAxis == Axis.vertical) {
      rect = const Offset(0.0, 0.0) & Size(shortLength, longLength);
    } else {
      rect = const Offset(0.0, 0.0) & Size(longLength, shortLength);
    }

    // Move [rect] to correct location on screen.
    if (settings.buttonAlignment == Alignment.topRight) {
      rect = rect.moveTopRightTo(basePageViewRect!.topRight);
    } else if (settings.buttonAlignment == Alignment.topLeft) {
      rect = rect.moveTopLeftTo(basePageViewRect!.topLeft);
    }
    return rect;
  }

  /// Generates a list of buttons.
  List<Widget> buttonArrayGenerator(Settings settings) {
    // Take a local copy of [buttonCoordinates] for speed.
    List<double> coordinates = buttonCoordinates;

    // Loop over items in [buttonSpecList], convert each to its
    // corresponding [button] and store result in [buttonList].
    List<Widget> buttonList = [];
    for (int i = 0; i < settings.buttonSpecList.length; i++) {
      //  Defines the [button] to be added to [buttonList] in this iteration.
      Button button = Button(
        buttonSpec: settings.buttonSpecList[i],
      );

      // Treat horizontal and vertical axes differently.
      if (settings.buttonAxis == Axis.horizontal) {
        // The top and bottom inputs to [Positioned] must be 0.0 or null,
        // depending on whether the selected alignment is top or bottom.
        //
        // The left and right inputs to [Positioned] must be non-zero
        // coordinates or null, depending on whether the selected alignment
        // is left or right.
        buttonList.add(Positioned(
          top: (settings.buttonAlignment.y < 0) ? 0 : null,
          bottom: (settings.buttonAlignment.y > 0) ? 0 : null,
          left: (settings.buttonAlignment.x < 0) ? coordinates[i] : null,
          right: (settings.buttonAlignment.x > 0) ? coordinates[i] : null,
          child: button,
        ));
      }

      // Treat horizontal and vertical axes differently.
      if (settings.buttonAxis == Axis.vertical) {
        // The left and right inputs to [Positioned] must be 0.0 or null,
        // depending on whether the selected alignment is left or right.
        //
        // The top and bottom inputs to [Positioned] must be non-zero
        // coordinates or null, depending on whether the selected alignment
        // is top or bottom.
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
    Settings settings = watch<SettingsService, Settings>();

    // Generate the array of buttons.
    List<Widget> buttonArray = buttonArrayGenerator(settings);

    // Return an instance of [Stack] with its children defined to be a
    // list of buttons. [buttonArray] is generated by [buttonArrayGenerator]
    // and has length equal to buttonSpecList.length.
    return Stack(
      // alignment: Alignment.bottomRight,
      children: buttonArray,
    );
  }
}
