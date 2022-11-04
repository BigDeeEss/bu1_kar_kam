// //  Import flutter packages.
// import 'package:flutter/material.dart';
//
// // Import project-specific files.
// import 'package:kar_kam/lib/data_store.dart';
//
// class GlobalASettings extends StatefulWidget {
//   GlobalASettings({
//     Key? key,
//     required this.child,
//   }) : super(key: key) {
//     globalAppSettingsData = GlobalData(
//       child: child,
//       data: GlobalASettingsData(),
//       key: ValueKey('GlobalASettings'),
//     );
//   }
//
//   final Widget child;
//
//   late GlobalData globalAppSettingsData;
//
//   static GlobalData of(BuildContext context) {
//     return GlobalData.of(context, ValueKey('GlobalASettings')).data;
//   }
//
//   @override
//   State<GlobalASettings> createState() => _GlobalASettingsState();
// }
//
// class _GlobalASettingsState extends State<GlobalASettings> {
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }

class GlobalASettingsData {
  /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
  ///
  /// Used for debugging widget screen location.
  bool drawLayoutBounds = true;

// bool get drawLayoutBounds => drawLayoutBoundsVal;
}
