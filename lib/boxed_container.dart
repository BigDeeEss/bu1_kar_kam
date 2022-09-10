//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/app_settings.dart';

/// [BoxedContainer] implements a Container that automatically prints its
/// bounding box as guideline for widget placement.
class BoxedContainer extends Container {
  BoxedContainer({
    Key? key,
    AlignmentGeometry? alignment,
    Widget? child,
    Clip clipBehavior = Clip.none,
    Color? color,
    BoxConstraints? constraints,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? height,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    double? width,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
  })  : super(
          key: key,
          alignment: alignment,
          child: child,
          clipBehavior: clipBehavior,
          constraints: constraints,
          decoration: decoration ?? BoxDecoration(
            border: AppSettings.drawLayoutBounds ? Border.all(
              width: borderWidth ?? 0.1,
              color: borderColor ?? Colors.black,
            ) : null,
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

  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
}
