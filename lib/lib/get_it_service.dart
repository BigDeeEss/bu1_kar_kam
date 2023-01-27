//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// A simple service provider offering a single interface between GetIt and app.
class GetItService {
  //  [allReady] indicates that all GetIt instances are ready for use.
  static Future<void> allReady() {
    return GetIt.instance.allReady();
  }

  //  Avoid memory leaks by not properly disposing of listenables
  //  attached to GetIt instance of T.
  static void dispose<T extends ChangeNotifier>(VoidCallback callBack) {
    GetIt.instance<T>().removeListener(callBack);
  }

  //  Add listener to GetIt instance of T.
  static void addListener<T extends ChangeNotifier>(VoidCallback callBack) {
    GetIt.instance
        .isReady<T>()
        .then((_) => GetIt.instance<T>().addListener(callBack));
  }

  //  The main service, returning the registered instance of T
  //  so that associated fields and methods can be accessed.
  static T instance<T extends ChangeNotifier>() {
    return GetIt.instance<T>();
  }

  //  Register an instance of T with Getit.
  static void register<T extends ChangeNotifier>(T instance) {
    GetIt.instance.registerSingleton<T>(instance, signalsReady: true);
  }

  //  Signal that all registered singletons are ready for use.
  static void signalReady<T extends ChangeNotifier>(T instance) {
    GetIt.instance.signalReady(instance);
  }
}
