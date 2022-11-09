// //  Import flutter packages.
// import 'package:flutter/material.dart';
//
// // Import project-specific files.
// import 'package:kar_kam/lib/data_notification.dart';
// import 'package:kar_kam/lib/notification_notifier.dart';
//
// class GlobalAppSettingsDevel extends StatefulWidget {
//   GlobalAppSettingsDevel({
//     required this.child,
//     Key? key,
//   }) : super(key: key) {
//     globalAppSettingsDevel = ValueNotifier(GlobalAppSettingsDevelStore());
//     notificationNotifier =
//         NotificationNotifier<DataNotification, GlobalAppSettingsDevelStore>(
//       child: child,
//       notificationData: globalAppSettingsDevel,
//       onNotification: (notification) {
//         print('Test dispatch method---GlobalAppSettingsDevelState...complete');
//         return false;
//       },
//     );
//   }
//
//   final Widget child;
//
//   late ValueNotifier<GlobalAppSettingsDevelStore> globalAppSettingsDevel;
//
//   late NotificationNotifier<DataNotification, GlobalAppSettingsDevelStore>
//       notificationNotifier;
//
//   static NotificationNotifierService<DataNotification, GlobalAppSettingsDevelStore>
//       of<DataNotification, GlobalAppSettingsDevelStore>(BuildContext context) =>
//           NotificationNotifier.of<DataNotification, GlobalAppSettingsDevelStore>(
//               context);
//
//   @override
//   State<GlobalAppSettingsDevel> createState() => GlobalAppSettingsDevelState();
// }
//
// class GlobalAppSettingsDevelState extends State<GlobalAppSettingsDevel> {
//   @override
//   Widget build(BuildContext context) {
//     return widget.notificationNotifier;
//   }
// }
//
// class GlobalAppSettingsDevelStore {
//   /// [drawLayoutBounds] triggers whether layout bounds are drawn or not.
//   ///
//   /// Used for debugging widget screen location.
//   bool drawLayoutBounds = true;
//
//   // bool get drawLayoutBounds => drawLayoutBoundsVal;
// }
