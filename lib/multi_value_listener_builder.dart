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
      widget.valueListenables[i].addListener(_valueChanged);
    }
  }

  @override
  void didUpdateWidget(MultiValueListenerBuilder oldWidget) {
    if (oldWidget.valueListenables != widget.valueListenables) {
      for (int i = 0; i < widget.valueListenables.length; i++) {
        oldWidget.valueListenables[i].removeListener(_valueChanged);
        values[i] = widget.valueListenables[i].value;
        widget.valueListenables[i].addListener(_valueChanged);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.valueListenables.length; i++) {
      widget.valueListenables[i].removeListener(_valueChanged);
    }
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      for (int i = 0; i < widget.valueListenables.length; i++) {
        values[i] = widget.valueListenables[i].value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, values, widget.child);
  }
}
