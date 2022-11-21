//  Import flutter packages.
import 'package:flutter/material.dart';

/// [GlobalData] provides a StatelessWidget wrapper for
/// [_GlobalDataService]. The associated build method ensures that
/// only one instance of _GlobalDataService exists per each level of context.
class GlobalData<T> extends StatelessWidget {
  const GlobalData({
    required Key? key,
    required this.child,
    required this.data,
  }) : localKey = key,
        super(key: key);

  final T data;

  /// The widget immediately below this instance of [GlobalData] in the
  /// widget tree.
  final Widget child;

  final Key? localKey;

  /// A local getter for key required by [of].
  Key? get key {
    return localKey;
  }

  /// [of] returns a copy of [_GlobalDataService] which matches the key
  /// provided, or passes the search on up the widget tree if not.
  static _GlobalDataService of(BuildContext context, Key key) {
    //  Get instance of [_GlobalDataService] immediately above this
    //  instance of [DataNotifier] in the widget tree.
    _GlobalDataService? result =
        context.dependOnInheritedWidgetOfExactType<_GlobalDataService>();

    //  Using 'is' promotes result to type _GlobalDataService in what
    //  follows so that the comparison 'key != result.key' can be made.
    if (result is _GlobalDataService) {
      if (key != result.key) {
        //  If keys do not match then continue search up the widget tree.
        return GlobalData.of(result.context, key);
      }
    } else {
      //  No instance of _GlobalDataService can be found in the widget tree
      //  so force the following assert to fail and provide a message to the
      //  user.
      assert(result is _GlobalDataService,
        'No GlobalData with key $key found in context: '
        'Try wrapping the call to [of] in a builder.'
      );
    }
    return result!;
  }

  //  Wrapping the instance of _GlobalDataService in a build method
  //  ensures that only one instance of DataNotifier is present at each
  //  level in the widget tree. THIS IS THE PRIMARY REASON WHY
  //  _GlobalDataService IS WRAPPED BY DataNotifier.
  @override
  Widget build(BuildContext context) {
    return _GlobalDataService(
      key: key,
      child: child,
      context: context,
      data: data,
    );
  }
}



/// [_GlobalDataService] provides the mechanism by which [GlobalData]
/// is able to pass [data] down the widget tree.
class _GlobalDataService extends InheritedWidget {
  _GlobalDataService({
    required Key? key,
    required Widget child,
    required this.context,
    required this.data,
  }) : super(key: key, child: child);

  var data;

  /// [context] is used when passing on the search for further instances of
  /// [_GlobalDataService] up the widget tree.
  final BuildContext context;

  @override
  bool updateShouldNotify(_GlobalDataService old) => data != old.data;
}
