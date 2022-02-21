//  Import dart and flutter packages.
import 'package:flutter/material.dart';

/// [DataNotification] allows data of any sort to be bubbled up the
/// widget tree.
class DataNotification extends LayoutChangedNotification {
  DataNotification({
    required this.data,
  });

  var data;
}