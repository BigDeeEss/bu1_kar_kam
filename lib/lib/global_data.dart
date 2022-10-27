//  Import flutter packages.
import 'package:flutter/material.dart';

/// [GlobalData] provides a StatelessWidget wrapper for
/// [_DataNotifierService]. The associated build method ensures that
/// only one instance of _DataNotifierService exists per each level of context.
class GlobalData extends StatelessWidget {
  GlobalData({
    required Key? key,
    required this.child,
    this.data,
  }) : localKey = key,
        super(key: key);

  /// [data] can be of any type and so var is used here.
  var data;

  /// The widget immediately below this instance of [GlobalData] in the
  /// widget tree.
  final Widget child;

  final Key? localKey;

  /// A local getter for key required by [of].
  Key? get key {
    return localKey;
  }

  /// [of] returns a copy of [_DataNotifierService] which matches the key
  /// provided, or passes the search on up the widget tree if not.
  static _DataNotifierService of(BuildContext context, Key key) {
    //  Get instance of [_DataNotifierService] immediately above this
    //  instance of [DataNotifier] in the widget tree.
    _DataNotifierService? result =
        context.dependOnInheritedWidgetOfExactType<_DataNotifierService>();

    //  Using 'is' promotes result to type _DataNotifierService in what
    //  follows so that the comparison 'key != result.key' can be made.
    if (result is _DataNotifierService) {
      if (key != result.key) {
        //  If keys do not match then continue search up the widget tree.
        return GlobalData.of(result.context, key);
      } else {
        //  If key matches the search criterion then return 'result'.
        return result;
      }
    } else {
      //  No instance of _DataNotifierService can be found in the widget tree
      //  so force the following assert to fail and provide a message to the
      //  user.
      assert(result is _DataNotifierService,
        'No DataNotifier with key $key found in context: '
        'Try wrapping the call to [of] in a builder.'
      );
      return result!;
      return _DataNotifierService(
        key: UniqueKey(),
        child: Container(),
        context: context,
      );
    }
  }

  //  Wrapping the instance of _DataNotifierService in a build method
  //  ensures that only one instance of DataNotifier is present at each
  //  level in the widget tree. THIS IS THE PRIMARY REASON WHY
  //  _DataNotifierService IS WRAPPED BY DataNotifier.
  @override
  Widget build(BuildContext context) {
    return _DataNotifierService(
      key: key,
      child: child,
      context: context,
      data: data,
    );
  }
}



/// [_DataNotifierService] provides the mechanism by which [GlobalData]
/// is able to pass [data] down the widget tree.
class _DataNotifierService extends InheritedWidget {
  _DataNotifierService({
    required Key? key,
    required Widget child,
    required this.context,
    this.data,
  }) : super(key: key, child: child);

  /// [data] can be of any type and so var is used here.
  var data;

  /// [context] is used when passing on the search for further instances of
  /// [_DataNotifierService] up the widget tree.
  final BuildContext context;

  @override
  bool updateShouldNotify(_DataNotifierService old) => data != old.data;
}
