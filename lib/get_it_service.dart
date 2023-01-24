//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class GetItService {
  // GetItService() {
  //   getItServiceInitialise();
  // }

  static void dispose<T extends ChangeNotifier>() {}

  static void init<T extends ChangeNotifier>(VoidCallback callBack) {
    print('executing init...');
    GetIt.instance
        .isReady<T>()
        .then((_) => GetIt.instance<T>().addListener(callBack));
  }

  //  Define an instance of GetIt and register T.
  static void register<T extends ChangeNotifier>(T instance) {
    print('executing register...');
    GetIt.instance.registerSingleton<T>(instance, signalsReady: true);
  }

  // void getItServiceInitialise() {
  //   Future.delayed(const Duration(seconds: 1))
  //       .then((_) => GetIt.instance.signalReady(this));
  // }
}
