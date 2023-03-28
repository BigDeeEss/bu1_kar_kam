// Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/kar_kam.dart';
import 'package:kar_kam/lib/get_it_service.dart';
import 'package:kar_kam/settings.dart';
import 'package:kar_kam/settings_service.dart';

/// App start point.
void main() {
  // Use [GetItService] as the single point of access to GetIt to
  // register an instance of [SettingsService].
  GetItService.register<Settings>(SettingsService());

  // Run the app.
  runApp(KarKam());
}
