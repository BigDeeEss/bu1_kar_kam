//  Import flutter packages.
import 'package:flutter/material.dart';

/// [DataStore] stores data of type T in [data] and makes it
/// available to all of its descendants via the [_DataStoreService] class.
class DataStore<T> extends StatelessWidget {
  const DataStore({
    required Key? key,
    required this.child,
    required this.data,
  }) : super(key: key);

  /// [child] is the immediate descendant of [DataStore].
  final Widget child;

  /// [data] is passed to [_DataStoreService] which makes
  /// it available to all descendants in the widget tree.
  final T data;

  /// Allow widgets below [DataStore] in the widget tree to access
  /// the data stored in [data].
  static _DataStoreService<T> of<T>(BuildContext context, Key key) {
    //  Get instance of _GlobalDataTmpService<T> immediately above this
    //  instance of GlobalDataTmp<T> in the widget tree.
    _DataStoreService<T>? result =
        context.dependOnInheritedWidgetOfExactType<_DataStoreService<T>>();

    //  Using 'is' promotes result to type _GlobalDataService<T> in what
    //  follows so that the comparison 'key != result.key' can be made.
    //  Without 'is' result.key has no specific meaning.
    if (result is _DataStoreService<T>) {
      if (key != result.key) {
        //  If keys do not match then continue search up the widget tree.
        result = DataStore.of<T>(result.context, key);
      }
    } else {
      //  Attempt to assert a contradiction so that 'of' fails.
      assert(
          result != null,
          'No _GlobalDataTmpService of the correct type found in context: '
          'Try wrapping the call to [of] in a builder or specifying the type, '
          'for example GlobalDataTmp<int>(...).'
      );
    }
    return result!;
  }

  @override
  Widget build(BuildContext context) {
    //  Insert an instance of _GlobalDataTmpService before child so that
    //  descendant widgets can access data via 'of'.
    return _DataStoreService(
      key: key,
      child: child,
      context: context,
      data: data,
    );
  }
}

/// [_DataStoreService] allows descendant widgets to access [data].
class _DataStoreService<T> extends InheritedWidget {
  const _DataStoreService({
    Key? key,
    required Widget child,
    required this.context,
    required this.data,
  }) : super(key: key, child: child);

  /// [context] is used when passing on the search for further instances of
  /// [_DataStoreService] up the widget tree.
  final BuildContext context;

  /// [data] is made accessible to descendant widgets via GlobalDataTmp.of.
  final T data;

  /// Allow [_DataStoreService] to notify listenable objects
  /// of updates to [data].
  @override
  bool updateShouldNotify(_DataStoreService<T> old) => data != old.data;
}
