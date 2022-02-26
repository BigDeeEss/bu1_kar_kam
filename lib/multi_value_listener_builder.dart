// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

// import 'framework.dart';
import 'package:flutter/material.dart';

typedef MultiValueWidgetBuilder =
    Widget Function(BuildContext context, List<dynamic> values, Widget? child);

class MultiValueListenerBuilder extends StatefulWidget {
  const MultiValueListenerBuilder({
    Key? key,
    required this.valueListenables,
    required this.builder,
    this.child,
  })  : assert(valueListenables.length != 0),
        super(key: key);

  final List<ValueListenable<dynamic>> valueListenables;

  final MultiValueWidgetBuilder builder;

  final Widget? child;

  @override
  State<StatefulWidget> createState() => _MultiValueListenerBuilderState();
}

class _MultiValueListenerBuilderState extends State<MultiValueListenerBuilder> {
  late List<dynamic> values;

  @override
  void initState() {
    super.initState();
    values = [];
    for (int i = 0; i < widget.valueListenables.length; i++) {
      values.add(widget.valueListenables[i].value);
    }
    // widget.valueListenable.addListener(_valueChanged);
  }

//   @override
//   void didUpdateWidget(MultiValueListenerBuilder<T> oldWidget) {
//     if (oldWidget.valueListenable != widget.valueListenable) {
//       oldWidget.valueListenable.removeListener(_valueChanged);
//       value = widget.valueListenable.value;
//       widget.valueListenable.addListener(_valueChanged);
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   void dispose() {
//     widget.valueListenable.removeListener(_valueChanged);
//     super.dispose();
//   }
//
//   void _valueChanged() {
//     setState(() { value = widget.valueListenable.value; });
//   }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, values, widget.child);
  }
}
