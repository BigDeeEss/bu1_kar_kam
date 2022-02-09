//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/page_specs.dart';
import 'package:kar_kam/base_page.dart';

class ZoomPageTransition extends PageRouteBuilder {
  /// Implements a zooming page transition from the centre out.
  final PageSpec pageSpec;

  ZoomPageTransition({
    //  Add constructor details specific to ZoomPageTransition.
    required this.pageSpec,
  }) : super(
    //  Add constructor details specific to PageRouteBuilder.
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) => BasePage(
      pageSpec: pageSpec,
    ),

    //  Define page transition PLUS button animation time.
    transitionDuration: Duration(milliseconds: AppSettings.pageTransitionTime),

    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) => ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: child,
    ),
  );
}
