//  Import flutter packages.

import 'package:flutter/material.dart';

abstract class SettingsDataTwo {}

class SettingsDataTwoImplementation<T extends SettingsDataTwo>
    extends ValueNotifier<T> {
  SettingsDataTwoImplementation(super.value);
}
