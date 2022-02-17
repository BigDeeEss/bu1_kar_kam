//  Import flutter packages.
import 'package:flutter/material.dart';
// import 'package:rect_getter/rect_getter.dart';

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

  static double? mainAxisPos(int i) {
    return (AppSettings.buttonAlignment.x < 0)
        ? 100.0*i
      : 0.0;
  }

  static double? crossAxisPos(int i) {
    return (AppSettings.buttonAlignment.x > 0)
      ? 100.0*i
      : 0.0;
  }

  // /// [rectGetterKey] is a unique global key which can be passed to
  // /// RectGetter.getRectFromKey in order to get the bounding rectangle
  // /// for the Button class.
  // final GlobalKey<RectGetterState> rectGetterKey = RectGetter.createGlobalKey();

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   print('RectGetter: absolute coordinates on screen: '
    //       '${RectGetter.getRectFromKey(rectGetterKey)}');
    // });

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
    return Container(
      decoration: BoxDecoration(
        border: AppSettings.drawLayoutBounds
            ? Border.all(width: 0.0, color: Colors.redAccent)
            : null,
      ),
      child: Padding(
        padding: (AppSettings.buttonAlignment.y < 0)
            ? AppSettings.buttonPaddingDown
            : AppSettings.buttonPaddingUp,
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
