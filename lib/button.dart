//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/button_specs.dart';

/// [Button] implements a copy of FloatingActionButton, including the
/// geometrical and functional aspects of buttonSpecs.
class Button extends StatelessWidget {
  Button({
    Key? key,
    required this.buttonSpec,
  }) : super(key: key);

  /// [buttonSpec] defines the button characteristics.
  final ButtonSpec buttonSpec;

  @override
  Widget build(BuildContext context) {
    //  IconButton with a circular background and geometry-dependent padding.
    //  Insert an instance of Container in order to offer layout bounds.
    return Container(
      decoration: BoxDecoration(
        border: this.buttonSpec.drawLayoutBounds
            ? Border.all(width: 0.0, color: Colors.redAccent)
            : null,
      ),
      child: Padding(
        padding: this.buttonSpec.buttonPadding,
        child: Container(
          decoration: BoxDecoration(
            border: this.buttonSpec.drawLayoutBounds
                ? Border.all(width: 0.0, color: Colors.redAccent)
                : null,
          ),
          child: CircleAvatar(
            radius: this.buttonSpec.size,
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
