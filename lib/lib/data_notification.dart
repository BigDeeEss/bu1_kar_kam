//  Import dart and flutter packages.
import 'package:flutter/material.dart';

/// [DataNotification] bubbles data of any sort up the widget tree.
class DataNotification<T> extends Notification {
  const DataNotification({
    required this.data,
  });

  final T data;
}