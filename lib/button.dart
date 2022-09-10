//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/boxed_container.dart';
import 'package:kar_kam/button_specs.dart';

/// Implements a copy of FloatingActionButton.
class Button extends StatelessWidget {
  Button({
    Key? key,
    required this.buttonSpec,
  }) : super(key: key);

  /// [buttonSpec] defines the visual characteristics and activation rules.
  final ButtonSpec buttonSpec;

  @override
  Widget build(BuildContext context) {
    //  An IconButton with a circular background.
    //
    //  Insert an instance of Container in order to offer layout bounds.
    return BoxedContainer(
      borderColor: Colors.redAccent,
      child: Padding(
        padding: buttonSpec.buttonPadding,
        child: BoxedContainer(
          borderColor: Colors.redAccent,
          child: CircleAvatar(
            radius: buttonSpec.size,
            backgroundColor: Colors.lightBlue,
            child: IconButton(
              icon: buttonSpec.icon,
              color: Colors.white,
              onPressed: () => buttonSpec.onPressed(context),
            ),
          ),
        ),
        // child: Container(
        //   decoration: BoxDecoration(
        //     border: this.buttonSpec.drawLayoutBounds
        //         ? Border.all(width: 0.0, color: Colors.redAccent)
        //         : null,
        //   ),
        //   child: CircleAvatar(
        //     radius: this.buttonSpec.size,
        //     backgroundColor: Colors.lightBlue,
        //     child: IconButton(
        //       icon: this.buttonSpec.icon,
        //       color: Colors.white,
        //       onPressed: () => this.buttonSpec.onPressed(context),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
