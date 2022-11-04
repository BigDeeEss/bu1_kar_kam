//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/lib/data_store.dart';

/// [NotificationDataStoreCallback] defines the form of callback that is
/// acceptable to [NotificationDataStore].
typedef NotificationDataStoreCallback<T extends Notification>
    = bool Function(T notification);

class NotificationDataStore<T extends Notification, U> extends DataStore<U> {
  const NotificationDataStore({
    required Key? key,
    required Widget child,
    required U data,
    required this.onNotification,
  }) : super(
    key: key,
    child: child,
    data: data,
  );

  /// [onNotification] is the user-supplied callback that defines what to
  /// do when [data] is updated.
  final NotificationDataStoreCallback onNotification;

  @override
  Widget build(BuildContext context) {
    //  Define a listener object for notifications of type T.
    NotificationListener<T> listener = NotificationListener<T>(
      onNotification: onNotification,
      child: child,
    );

    //  Insert an instance of DataStoreService before child so that
    //  descendant widgets can access data via 'of'.
    return DataStoreService<U>(
      key: key,
      child: listener,
      context: context,
      data: data,
    );
  }
}
