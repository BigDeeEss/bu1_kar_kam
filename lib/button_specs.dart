//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:dash_cam_app/lib/custom_icons.dart';
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/page_specs.dart';
// import 'package:dash_cam_app/zoom_page_transition.dart';

class ButtonSpec {
  /// Class for ease of reference to specific button settings.
  const ButtonSpec({
    required this.icon,
    required this.onPressed,
    required this.size,
  });

  //  The [icon] indicating the the destination page or action.
  final Icon icon;

  //  [onPressed] defines the action to be taken when the button is activated.
  final void Function(BuildContext context) onPressed;

  //  [size] is the button characteristic dimension.
  final double size;
}

//  Home page button specs.
ButtonSpec homeButton = ButtonSpec(
  // icon: Icon(CustomIcons.home),
  icon: Icon(FontAwesomeIcons.home),
  onPressed: (context) {
    // Navigator.of(context).pushReplacement(ZoomPageTransition(
    //   pageSpec: homePage,
    // ));
  },
  size: AppSettings.buttonSize,
);

//  Files page button specs.
ButtonSpec filesButton = ButtonSpec(
  // icon: Icon(CustomIcons.file_video),
  icon: Icon(FontAwesomeIcons.fileVideo),
  onPressed: (context) {
    // Navigator.of(context).pushReplacement(ZoomPageTransition(
    //   pageSpec: filesPage,
    // ));
  },
  size: AppSettings.buttonSize,
);

//  Settings page button specs.
ButtonSpec settingsButton = ButtonSpec(
  // icon: Icon(CustomIcons.cog_1),
  icon: Icon(FontAwesomeIcons.cog),
  onPressed: (context) {
    // Navigator.of(context).pushReplacement(ZoomPageTransition(
    //   pageSpec: settingsPage,
    // ));
  },
  size: AppSettings.buttonSize,
);

