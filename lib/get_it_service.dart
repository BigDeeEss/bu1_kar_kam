//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class GetItService<U> extends ChangeNotifier {
  GetItService() {
    getItServiceInitialise();
  }

  void getItServiceInitialise() {
    Future.delayed(const Duration(seconds: 1))
        .then((_) => GetIt.instance.signalReady(this));
  }
}
