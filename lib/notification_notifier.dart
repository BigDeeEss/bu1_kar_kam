//  Import flutter packages.
import 'package:flutter/material.dart';


/// [NotificationNotifierCallback] defines the form of callback that is
/// acceptable to [NotificationNotifier].
typedef NotificationNotifierCallback<T extends Notification>
    = bool Function(T notification);


/// [NotificationNotifier] combines instances of NotificationListener
/// and [_NotificationNotifierService].
///
/// [NotificationNotifier] catches and stores notifications propagating
/// up the widget tree, stores the data in [notificationData], and notifies
/// listenable objects below it in the widget tree of updates via the
/// [_NotificationNotifierService] class.
///
/// [NotificationNotifier] makes [notificationData] available to listenable
/// objects below it in the widget tree via the [of] method defined below.
class NotificationNotifier<T extends Notification, U> extends StatelessWidget {
  NotificationNotifier({
    Key? key,
    required this.child,
    required this.notificationData,
    required this.onNotification,
  }) : super(key: key);

  /// [child] is the immediate descendant of [NotificationNotifier].
  final Widget child;

  /// [notificationData] is passed to [_NotificationNotifierService].
  ///
  /// [_NotificationNotifierService] notifies listenable objects below it
  /// in the widget tree of updates (to [notificationData]).
  ///
  /// The [of] method bound to [NotificationNotifier] makes [notificationData]
  /// available to listenable objects below it in the widget tree.
  final ValueNotifier<U> notificationData;

  /// [onNotification] is the user-supplied callback that defines when
  /// listenable variables are notified of updates to [notificationData].
  NotificationNotifierCallback onNotification;

  /// [listener] listens out for notifications of type T.
  ///
  /// On the condition(s) defined by the user in [onNotification], [listener]
  /// updates [notificationData], [_NotificationNotifierService] and therefore
  /// listenable objects below [NotificationNotifier] in the widget tree
  /// of these changes.
  late NotificationListener<T> listener;

  /// [notificationNotifier] notifies listenable objects below it in the
  /// widget tree of updates to [notificationData].
  late _NotificationNotifierService<T, U> notificationNotifier;

  /// Allow widgets below [NotificationNotifier] in the widget tree to access
  /// the data stored in [notificationData] via the [notificationNotifier]
  /// instance of [_NotificationNotifierService].
  static _NotificationNotifierService<T, U> of <T, U> (BuildContext context) {
    final _NotificationNotifierService<T, U>? result = context
        .dependOnInheritedWidgetOfExactType<_NotificationNotifierService<T, U>>();
    assert(result != null,
      'No _NotificationNotifierService found in context: '
      'Try wrapping the call to [of] in a builder.'
    );
    // print(result);
    return result!;
  }

  @override
  Widget build(BuildContext context) {
    //  Define a listener object for notifications of type T.
    listener = NotificationListener<T>(
      onNotification: onNotification,
      child: child,
    );
    //  Define a notificationNotifier object using listener and
    //  notificationData.
    notificationNotifier = _NotificationNotifierService<T, U>(
      child: listener,
      notificationData: notificationData,
    );
    return notificationNotifier;
  }
}


/// [_NotificationNotifierService] notifies listenable objects below
/// it in the widget tree of changes to [notificationData].
class _NotificationNotifierService<T, U> extends InheritedWidget {
  _NotificationNotifierService({
    Key? key,
    required this.child,
    required this.notificationData,
  }) : super(key: key, child: child);

  /// [child] is the immediate descendant of [_NotificationNotifierService].
  final Widget child;

  /// [notificationData] stores data that listenable objects below
  /// [_NotificationNotifierService] in the widget tree can access.
  ///
  /// The value stored in [notificationData] is defined by the callback
  /// functon defined by the user.
  final ValueNotifier<U> notificationData;

  /// Allow [_NotificationNotifierService] to notify listenable objects
  /// of updates to [notificationData].
  @override
  bool updateShouldNotify(_NotificationNotifierService<T, U> old) =>
      notificationData != old.notificationData;
}


