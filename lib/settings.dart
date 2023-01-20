//  Import flutter packages.
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//  Import project-specific files.
import 'package:kar_kam/app_model.dart';

class Settings extends StatefulWidget {
  const Settings({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void dispose() {
    GetIt.instance<AppModel>().removeListener(update);

    super.dispose();
  }

  @override
  void initState() {
    //  Access the instance of the registered AppModel
    //  As we don't know for sure if AppModel is already ready we use the
    //  then method to add a listener only when it is ready.
    GetIt.instance
        .isReady<AppModel>()
        .then((_) => GetIt.instance<AppModel>().addListener(update));

    super.initState();
  }

  /// The [update] callback is used by the Listener attached to the registered
  /// instance of AppModel.
  void update() => setState(() => {});

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
