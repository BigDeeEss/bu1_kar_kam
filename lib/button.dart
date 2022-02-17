//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/button_specs.dart';

/// [Button] implements a FloatingActionButton copy, including the
/// geometrical and functional aspects of buttonSpecs.
class Button extends StatelessWidget {
  /// Implements a single button item in ButtonArray.
  Button({
    Key? key,
    required this.buttonSpec,
  }) : super(key: key);

  /// [buttonSpec] defines the button characteristics.
  final ButtonSpec buttonSpec;

  @override
  Widget build(BuildContext context) {
    //  IconButton with a circular background and geometry-dependent padding.
    //  The RectGetter class provides a method for obtaining
    //  a widget's bounding rectangle.
    return Container(
      decoration: BoxDecoration(
        border: AppSettings.drawLayoutBounds
            ? Border.all(width: 0.0, color: Colors.redAccent)
            : null,
      ),
      child: Padding(
        padding: AppSettings.buttonPadding,
        child: Container(
          decoration: BoxDecoration(
            border: AppSettings.drawLayoutBounds
                ? Border.all(width: 0.0, color: Colors.redAccent)
                : null,
          ),
          child: CircleAvatar(
            radius: this.buttonSpec.size / 2.0,
            backgroundColor: Colors.lightBlue,
            child: IconButton(
              icon: this.buttonSpec.icon,
              color: Colors.white,
              onPressed: () => this.buttonSpec.onPressed(context),
            ),
          ),
        ),
      ),
    );
  }
}
