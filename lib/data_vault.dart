//  Import flutter packages.
import 'package:flutter/material.dart';

/// [DataVaultService] provides the mechanism by which [DataVault]
/// is able to pass [data] down the widget tree.
class DataVaultService extends InheritedWidget {
  DataVaultService({
    required Key? key,
    required Widget child,
    required this.context,
    this.data,
  }) : super(key: key, child: child);

  /// [data] can be of any type and so var is used here.
  var data;

  /// [context] is used when passing on the search for further instances of
  /// [DataVaultService] up the widget tree.
  final BuildContext context;

  @override
  bool updateShouldNotify(DataVaultService old) => data != old.data;
}

/// [DataVault] provides a StatelessWidget wrapper for
/// [DataVaultService]. The associated build method ensures that
/// only one instance of DataVaultService exists per each level of context.
class DataVault extends StatelessWidget {
  DataVault({
    required Key? key,
    required this.child,
    this.data,
  }) : localKey = key,
        super(key: key);

  /// [data] can be of any type and so var is used here.
  var data;

  /// The widget immediately below this instance of [DataVault] in the
  /// widget tree.
  final Widget child;

  final Key? localKey;
  Key? get key {
    return localKey;
  }

  /// [of] returns a copy of [DataVaultService] which matches the key
  /// provided, or passes the search on up the widget tree if not.
  static DataVaultService of(BuildContext context, Key key) {
    //  Get instance of [DataVaultService] immediately above this
    //  instance of [DataVault] in the widget tree.
    DataVaultService? result =
        context.dependOnInheritedWidgetOfExactType<DataVaultService>();

    //  Using 'is' promotes result to type DataVaultService in what
    //  follows so that the comparison 'key != result.key' can be made.
    if (result is DataVaultService) {
      if (key != result.key) {
        //  If keys do not match then continue search up the widget tree.
        return DataVault.of(result.context, key);
      } else {
        //  If key matches the search criterion then return 'result'.
        return result;
      }
    } else {
      //  No instance of DataVaultService can be found in the widget tree
      //  so force the following assert to fail and provide a message to the
      //  user.
      assert(result is DataVaultService,
        'No DataVault with key $key found in context: '
        'Try wrapping the call to [of] in a builder.'
      );
      return result!;
    }
  }

  //  Wrapping the instance of DataVaultService in a build method
  //  ensures that only one instance of DataVault is present at each
  //  level in the widget tree.
  @override
  Widget build(BuildContext context) {
    return DataVaultService(
      key: key,
      child: child,
      context: context,
      data: data,
    );
  }
}

