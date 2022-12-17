//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/settings.dart';
import 'package:kar_kam/lib/data_notification.dart';
import 'package:kar_kam/lib/notification_data_store.dart';

/// [BoxedContainer] implements a Container and prints its bounding box.
///
/// [BoxedContainer] essentially calls an instance of Container with an
/// updated decoration if one is not specifically given.
///
/// [BoxedContainer] defaults to Container if AppSettings.drawLayoutBounds
/// is false.
class BoxedContainer extends StatelessWidget {
  const BoxedContainer({
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
    this.borderWidth,
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
  final double? borderWidth;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return _BoxedContainer(
      alignment: alignment,
      child: child,
      clipBehavior: clipBehavior,
      color: color,
      constraints: constraints,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      height: height,
      margin: margin,
      padding: padding,
      transform: transform,
      transformAlignment: transformAlignment,
      width: width,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      drawLayoutBounds:
          NotificationDataStore.of<SettingsService, DataNotification>(
                  context, const ValueKey('AppSettings')
          ).data.drawLayoutBounds,
    );
  }
}

class _BoxedContainer extends Container {
  _BoxedContainer({
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
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
    bool? drawLayoutBounds,
  }) : super(
          key: key,
          alignment: alignment,
          child: child,
          clipBehavior: clipBehavior,
          constraints: constraints,
          decoration: decoration ??
              BoxDecoration(
                border: (drawLayoutBounds ?? true)
                    ? Border.all(
                        width: borderWidth ?? 0.1,
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
