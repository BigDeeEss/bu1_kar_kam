//  Import flutter packages.
import 'package:flutter/material.dart';

//  Import project-specific files.
import 'package:kar_kam/app_model.dart';
import 'package:kar_kam/get_it_service.dart';
import 'package:kar_kam/kar_kam.dart';

//  App start point.
void main() {
  //  Define an instance of GetIt and register AppModel.
  GetItService.register<AppModel>(AppModel());

  //  Run the app.
  runApp(KarKam());
}