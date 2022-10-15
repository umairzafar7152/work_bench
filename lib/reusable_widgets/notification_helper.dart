// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationsHelper {
//
//   static final _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static final iosInitialize = IOSInitializationSettings();
//
// //needs an icon
//   static final _initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   static final _initializationSettings =
//   new InitializationSettings(android: _initializationSettingsAndroid, iOS: iosInitialize);
//
//   static Future<void> init() async {
//     await _flutterLocalNotificationsPlugin.initialize(_initializationSettings);
//     tz.initializeDatabase([]);
//   }
//
//   static final _androidNotificationDetails = AndroidNotificationDetails(
//     'channel id',
//     'channel name',
//     'channel description',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//
//   static final _notificationDetails =
//   NotificationDetails(android: _androidNotificationDetails);
//
// // set Notification method
//   static Future<void> setNotification(tz.TZDateTime dateTime, int id) async {
//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       'scheduled title',
//       'scheduled body',
//       dateTime,
//       _notificationDetails,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
// // cancel Notification method
//   static Future<void> cancelNotification(int id) async {
//     await _flutterLocalNotificationsPlugin.cancel(id);
//   }
// }