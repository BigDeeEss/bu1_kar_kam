//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

//  Import project-specific files.
import 'package:kar_kam/settings_service.dart';

/// [BoxedContainer] implements a Container and prints its bounding box.
///
/// The [BoxedContainer] essentially calls an instance of Container with
/// a default decoration if one is not specifically given. [BoxedContainer]
/// defaults to Container if AppSettings.drawLayoutBounds is false.
class BoxedContainer extends StatelessWidget with GetItMixin {
  BoxedContainer({
    Key? key,
    this.alignment,
    this.child,
    this.clipBehavior = Clip.none,
    this.color,
    this.constraints,
    this.decoration,
    this.foregroundDecoration,
    this.height,
    this.margin,
    this.padding,
    this.transform,
    this.transformAlignment,
    this.width,
    this.borderColor,
    this.borderRadius,
  }) : super(key: key);

  //  Container-specific variables.
  final AlignmentGeometry? alignment;
  final Widget? child;
  final Clip clipBehavior;
  final Color? color;
  final BoxConstraints? constraints;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final double? width;

  //  _BoxedContainer-specific variables.
  final Color? borderColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    //  Watch for changes to SettingsService, specifically
    //  SettingsService.settingsData.
    final bool localDrawLayoutBounds =
        watchOnly((SettingsService m) => m.settingsData.drawLayoutBounds);

    return Container(
      alignment: alignment,
      child: child,
      clipBehavior: clipBehavior,
      // color: color,
      constraints: constraints,
      decoration: decoration ??
          BoxDecoration(
            border: localDrawLayoutBounds
                ? Border.all(
                    width: 0.1,
                    color: borderColor ?? Colors.black,
                  )
                : null,
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? 0.0),
            ),
            color: color,
          ),
      foregroundDecoration: foregroundDecoration,
      height: height,
      margin: margin,
      padding: padding,
      transform: transform,
      transformAlignment: transformAlignment,
      width: width,
    );
  }
}
