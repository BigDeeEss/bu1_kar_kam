//  Import dart and flutter packages.
import 'package:flutter/material.dart';

class DataNotification extends LayoutChangedNotification {
  DataNotification({
    required this.data,
  });

  var data;
}