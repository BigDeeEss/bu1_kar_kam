//  Import dart packages.
// import 'dart:ui';

extension MapExtension on Map {
  Map inverse() {
   return map((key, value) => MapEntry(value, key));
  }
}