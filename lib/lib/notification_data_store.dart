//  Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/lib/data_store.dart' show DataStoreService;

/// [NotificationDataStoreCallback] defines the form of callback that is
/// acceptable to [NotificationDataStore].
typedef NotificationDataStoreCallback<T extends Notification> = bool Function(
    T notification);

class NotificationDataStore<T, U extends Notification> extends StatelessWidget {
  const NotificationDataStore({
    required Key key,
    required this.child,
    required this.data,
    required this.onNotification,
  }) : super(key: key);

  /// [child] is the immediate descendant of [NotificationDataStore].
  final Widget child;

  /// [data] is passed to [DataStoreService] which makes
  /// it available to all descendants in the widget tree.
  final T data;

  /// [onNotification] is the user-supplied callback that defines what to
  /// do when [data] is updated.
  final NotificationDataStoreCallback<U> onNotification;

  /// Allow widgets below [DataStore] in the widget tree to access
  /// the data stored in [data].
  static DataStoreService<T> of<T, U>(BuildContext context, Key key) {
    //  Get instance of DataStoreService<T> immediately above the location
    //  in the widget tree where 'of' is called.
    DataStoreService<T>? result =
        context.dependOnInheritedWidgetOfExactType<DataStoreService<T>>();

    //  Using 'is' promotes result to type DataStoreService<T> in what
    //  follows so that the comparison 'key != result.key' can be made.
    //
    //  Without 'is' result.key has no specific meaning.
    if (result is DataStoreService<T>) {
      if (key != result.key) {
        //  If keys do not match then continue search up the widget tree.
        result = NotificationDataStore.of<T, U>(result.context, key);
      }
    } else {
      //  Assert a contradiction so that 'of' fails with error message.
      assert(
          result != null,
          'No DataStoreService of the correct type found in context: '
          'Try wrapping the call to [of] in a builder or specifying the type, '
          'for example NotificationDataStore<int>(...).'
      );
    }
    return result!;
  }

  @override
  Widget build(BuildContext context) {
    //  Define a listener object for notifications of type U.
    NotificationListener<U> listener = NotificationListener<U>(
      onNotification: onNotification,
      child: child,
    );

    //  Insert an instance of DataStoreService before child so that
    //  descendant widgets can access data via 'of'.
    return DataStoreService<T>(
      key: key,
      child: listener,
      context: context,
      data: data,
    );
  }
}
