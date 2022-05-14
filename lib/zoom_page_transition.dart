//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/app_settings.dart';
import 'package:kar_kam/base_page.dart';
import 'package:kar_kam/page_specs.dart';

/// [ZoomPageTransition] implements a zoom page transition from the centre out.
class ZoomPageTransition extends PageRouteBuilder {
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

    //  Define page transition animation time.
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
