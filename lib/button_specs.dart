//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings_orig.dart';
import 'package:kar_kam/base_page.dart';
import 'package:kar_kam/page_specs.dart';
// import 'package:kar_kam/lib/zoom_page_transition.dart';

/// [ButtonSpec] is a simple class containing the specs for on-screen buttons.
class ButtonSpec {
  ButtonSpec({
    required this.icon,
    required this.onPressed,
  });

  /// [drawLayoutBounds] toggles whether layout bounds are drawn or not.
  // final bool drawLayoutBounds = AppSettings.drawLayoutBounds;

  /// [icon] indicating the destination page or action.
  final Icon icon;

  /// [onPressed] defines the action to be taken when the button is activated.
  final void Function(BuildContext context) onPressed;

  /// [buttonPadding] is a radial padding beyond [buttonRadius].
  final EdgeInsetsDirectional buttonPadding = AppSettingsOrig.buttonPadding;

  /// [size] is the button characteristic dimension.
  final double size = AppSettingsOrig.buttonRadius;
}

//  Home page button specs.
ButtonSpec homeButton = ButtonSpec(
  icon: Icon(FontAwesomeIcons.home),
  onPressed: (context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => BasePage(
          pageSpec: homePage,
        ),
      ),
    );
    // Navigator.of(context).pushReplacement(ZoomPageTransition(
    //   pageSpec: homePage,
    // ));
  },
);

//  Files page button specs.
ButtonSpec filesButton = ButtonSpec(
  icon: Icon(FontAwesomeIcons.fileVideo),
  onPressed: (context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => BasePage(
          pageSpec: filesPage,
        ),
      ),
    );
    // Navigator.of(context).pushReplacement(ZoomPageTransition(
    //   pageSpec: filesPage,
    // ));
  },
);

//  Settings page button specs.
ButtonSpec settingsButton = ButtonSpec(
  icon: Icon(FontAwesomeIcons.cog),
  onPressed: (context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => BasePage(
          pageSpec: settingsPage,
        ),
      ),
    );
    // Navigator.of(context).pushReplacement(ZoomPageTransition(
    //   pageSpec: settingsPage,
    // ));
  },
);

