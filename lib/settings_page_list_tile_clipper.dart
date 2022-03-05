//  Import flutter packages.
import 'package:flutter/material.dart';


class SettingsPageListTileClipper extends CustomClipper<Path>{
  SettingsPageListTileClipper({
    required this.rect1,
    required this.rect2,
    Listenable? reclip,
  })  : super(reclip: reclip);

  Rect? rect1;

  Rect? rect2;

  @override
  Path getClip(Size size) {
    Path path1 = Path();
    print('SettingsPageListTileClipper, rect1 = $rect1');
    print('SettingsPageListTileClipper, rect2 = $rect2');
    if (rect1 != null) {
      path1.addRect(rect1!);
    }
    // Path path2 = Path();
    // path2.addRect(rect2);
    // Path path = Path.combine(PathOperation.difference, path1, path2);
    return path1;
    // }
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
