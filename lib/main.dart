//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//  Import project-specific files.
import 'package:kar_kam/app_model.dart';
import 'package:kar_kam/kar_kam.dart';

//  App start point.
void main() {
  //  Define an instance of GetIt and register AppModel.
  GetIt.instance.registerSingleton<AppModel>(AppModelImplementation(),
      signalsReady: true);

  //  Run the app.
  runApp(const KarKam());
}