//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/page_specs.dart';
import 'package:kar_kam/zoom_page_transition.dart';

/// [ButtonSpec] is a simple class containing the specs for on-screen buttons.
class ButtonSpec {
  ButtonSpec({
    required this.icon,
    required this.onPressed,
  });

  /// [drawLayoutBounds] toggles whether layout bounds are drawn or not.
  final bool drawLayoutBounds = AppSettings.drawLayoutBounds;

  /// [icon] indicating the the destination page or action.
  final Icon icon;

  /// [onPressed] defines the action to be taken when the button is activated.
  final void Function(BuildContext context) onPressed;

  /// [buttonPadding] is the radial amount of padding beyond [buttonRadiusInner].
  final EdgeInsetsDirectional buttonPadding = AppSettings.buttonPadding;

  /// [size] is the button characteristic dimension.
  final double size = AppSettings.buttonRadiusInner;
}

//  Home page button specs.
ButtonSpec homeButton = ButtonSpec(
  icon: Icon(FontAwesomeIcons.home),
  onPressed: (context) {
    Navigator.of(context).pushReplacement(ZoomPageTransition(
      pageSpec: homePage,
    ));
  },
);

//  Files page button specs.
ButtonSpec filesButton = ButtonSpec(
  icon: Icon(FontAwesomeIcons.fileVideo),
  onPressed: (context) {
    Navigator.of(context).pushReplacement(ZoomPageTransition(
      pageSpec: filesPage,
    ));
  },
);

//  Settings page button specs.
ButtonSpec settingsButton = ButtonSpec(
  icon: Icon(FontAwesomeIcons.cog),
  onPressed: (context) {
    Navigator.of(context).pushReplacement(ZoomPageTransition(
      pageSpec: settingsPage,
    ));
  },
);

