import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

abstract class AppModel extends ChangeNotifier {
  void incrementCounter();

  int get counter;
}

class AppModelImplementation extends AppModel {
  int _counter = 0;

  AppModelImplementation() {
    /// lets pretend we have to do some async initialization
    Future.delayed(Duration(seconds: 3)).then((_) => GetIt.instance.signalReady(this));
  }

  @override
  int get counter => _counter;

  @override
  void incrementCounter() {
    _counter++;
    print(_counter);
    notifyListeners();
  }
}
