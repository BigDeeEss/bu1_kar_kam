// Import flutter packages.
import 'package:flutter/material.dart';
import 'package:kar_kam/button_array.dart';
import 'package:kar_kam/lib/get_it_service.dart';
import 'package:kar_kam/settings.dart';
import 'package:kar_kam/settings_page_list_tile.dart';
import 'package:kar_kam/settings_service.dart';

class SlidingGuides extends StatelessWidget {
  const SlidingGuides({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get a current copy of app settings.
    Settings settings = GetItService.instance<SettingsService>().value;

    return Stack(
      children: [
        // Add two additional guidance circles for checking the sliding
        // motion of [SettingsPageListTile].
        // ToDo: delete these unnecessary guidance circles at some point.
        (settings.buttonAxis == Axis.horizontal) ? Positioned(
          top: (settings.buttonAlignment.y < 0) ? 0 : null,
          bottom: (settings.buttonAlignment.y > 0) ? 0 : null,
          left: (settings.buttonAlignment.x < 0)
              ? ButtonArray.buttonCoordinates.first
              : null,
          right: (settings.buttonAlignment.x > 0)
              ? ButtonArray.buttonCoordinates.first
              : null,
          child: CustomPaint(
            painter: OpenPainter(
              alignment: settings.buttonAlignment,
              axis: settings.buttonAxis,
              radius: settings.buttonRadius + settings.buttonPaddingMainAxis,
              shiftVal: ButtonArray.rect(context).shortestSide *
                  SettingsPageListTile.sf,
            ),
          ),
        ) : Positioned(
          top: (settings.buttonAlignment.y < 0)
              ? ButtonArray.buttonCoordinates.last
              : null,
          bottom: (settings.buttonAlignment.y > 0)
              ? ButtonArray.buttonCoordinates.last
              : null,
          left: (settings.buttonAlignment.x < 0) ? 0.0 : null,
          right: (settings.buttonAlignment.x > 0) ? 0.0 : null,
          child: CustomPaint(
            painter: OpenPainter(
              alignment: settings.buttonAlignment,
              axis: settings.buttonAxis,
              radius: settings.buttonRadius + settings.buttonPaddingMainAxis,
              shiftVal: ButtonArray.rect(context).shortestSide *
                  SettingsPageListTile.sf
            ),
          ),
        ),
        (settings.buttonAxis == Axis.horizontal) ? Positioned(
          top: (settings.buttonAlignment.y < 0) ? 0 : null,
          bottom: (settings.buttonAlignment.y > 0) ? 0 : null,
          left: (settings.buttonAlignment.x < 0)
              ? ButtonArray.buttonCoordinates.last
              : null,
          right: (settings.buttonAlignment.x > 0)
              ? ButtonArray.buttonCoordinates.last
              : null,
          child: CustomPaint(
            painter: OpenPainter(
              alignment: settings.buttonAlignment,
              axis: settings.buttonAxis,
              radius: settings.buttonRadius + settings.buttonPaddingMainAxis,
              shiftVal: 0.0,
            ),
          ),
        ) : Positioned(
          top: (settings.buttonAlignment.y < 0)
              ? ButtonArray.buttonCoordinates.last
              : null,
          bottom: (settings.buttonAlignment.y > 0)
              ? ButtonArray.buttonCoordinates.last
              : null,
          left: (settings.buttonAlignment.x < 0) ? 0.0 : null,
          right: (settings.buttonAlignment.x > 0) ? 0.0 : null,
          child: CustomPaint(
            painter: OpenPainter(
              alignment: settings.buttonAlignment,
              axis: settings.buttonAxis,
              radius: settings.buttonRadius + settings.buttonPaddingMainAxis,
              shiftVal: 0.0,
            ),
          ),
        ),
      ]
    );
  }
}

/// A custom painter for producing the guidance circles.
class OpenPainter extends CustomPainter{
  OpenPainter({
    required this.alignment,
    required this.axis,
    required this.radius,
    required this.shiftVal,
  });

  final Alignment alignment;

  final Axis axis;

  final double shiftVal;

  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color.fromRGBO(66, 165, 245, 0.5)
      ..style = PaintingStyle.fill;
    if (axis == Axis.horizontal) {
      if (alignment.y < 0 && alignment.x > 0) {
        canvas.drawCircle(Offset(-radius, radius + shiftVal), radius, paint1);
      }
      if (alignment.y < 0 && alignment.x < 0) {
        canvas.drawCircle(Offset(radius, radius + shiftVal), radius, paint1);
      }
      if (alignment.y > 0 && alignment.x > 0) {
        canvas.drawCircle(Offset(-radius, -radius - shiftVal), radius, paint1);
      }
      if (alignment.y > 0 && alignment.x < 0) {
        canvas.drawCircle(Offset(radius, -radius - shiftVal), radius, paint1);
      }
    }
    if (axis == Axis.vertical) {
      if (alignment.y < 0 && alignment.x > 0) {
        canvas.drawCircle(Offset(-radius, radius + shiftVal), radius, paint1);
      }
      if (alignment.y < 0 && alignment.x < 0) {
        canvas.drawCircle(Offset(radius, radius + shiftVal), radius, paint1);
      }
      if (alignment.y > 0 && alignment.x > 0) {
        canvas.drawCircle(Offset(-radius, -radius - shiftVal), radius, paint1);
      }
      if (alignment.y > 0 && alignment.x < 0) {
        canvas.drawCircle(Offset(radius, -radius - shiftVal), radius, paint1);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
