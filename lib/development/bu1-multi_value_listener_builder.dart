//  Import flutter packages.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef MultiValueWidgetBuilder
    = Widget Function(BuildContext context, List<dynamic> values, Widget? child);

class MultiValueListenerBuilder extends StatelessWidget {
  const MultiValueListenerBuilder({
    Key? key,
    required this.valueListenables,
    required this.builder,
    this.child,
  })  : assert(valueListenables.length != 0),
        super(key: key);

  /// List of [ValueListenable]s to listen to.
  // final ValueNotifier<List<dynamic>> valueListenables;
  final List<ValueListenable> valueListenables;

  /// The builder function to be called when value of any of the [ValueListenable] changes.
  /// The order of values list will be same as [valueListenables] list.
  // final Widget Function(BuildContext context,
  //     List<dynamic> values, Widget? child) builder;
  final MultiValueWidgetBuilder builder;

  /// An optional child widget which will be avaliable as child parameter in [builder].
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<dynamic>>(
      valueListenable: valueListenables,
      builder: ,
    );
  }
  // Widget build(BuildContext context) {
  //   return ValueListenableBuilder<double>(
  //     valueListenable: ValueNotifier(0.0),
  //     builder: (BuildContext context, double value, __,) {
  //       return Container();
  //     },
  //   );
  // }
}

