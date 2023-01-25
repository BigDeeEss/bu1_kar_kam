//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class GetItService {
  // GetItService() {
  //   getItServiceInitialise();
  // }

  static void dispose<T extends ChangeNotifier>(VoidCallback callBack) {
    GetIt.instance<T>().removeListener(callBack);
  }

  static void init<T extends ChangeNotifier>(VoidCallback callBack) {
    print('executing init...');
    GetIt.instance
        .isReady<T>()
        .then((_) => GetIt.instance<T>().addListener(callBack));
  }

  static T instance<T extends ChangeNotifier>() {
    return GetIt.instance<T>();
  }

  //  Define an instance of GetIt and register T.
  static void register<T extends ChangeNotifier>(T instance) {
    print('executing register...');
    GetIt.instance.registerSingleton<T>(instance, signalsReady: true);
  }

  static void signalReady<T extends ChangeNotifier>(T instance) {
    GetIt.instance.signalReady(instance);
  }

  // void getItServiceInitialise() {
  //   Future.delayed(const Duration(seconds: 1))
  //       .then((_) => GetIt.instance.signalReady(this));
  // }
}
