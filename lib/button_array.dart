//  Import dart and flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
// import 'package:kar_kam/animation_status_notification.dart';
// import 'package:kar_kam/app_settings.dart';
// import 'package:kar_kam/button.dart';
import 'package:kar_kam/button_specs.dart';
// import 'package:kar_kam/skewed_transition.dart';

/// [ButtonArray] implements a linear button array on screen.
class ButtonArray extends StatelessWidget {
  const ButtonArray({Key? key}) : super(key: key);

  /// [buttonSpecList] defines the specs for buttons on each screen.
  static List<ButtonSpec> buttonSpecList = [
    settingsButton,
    filesButton,
    homeButton,
  ];

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
