//  Import dart and flutter packages.
import 'package:flutter/material.dart';

/// [DataNotification] bubbles data of any sort up the widget tree.
class DataNotification extends Notification {
  DataNotification({
    required this.data,
  });

  var data;
}