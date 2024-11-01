// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class LocalNotificationHandler {

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =

//       FlutterLocalNotificationsPlugin();

//   LocalNotificationHandler() {

//     var initializationSettingsAndroid =

//         AndroidInitializationSettings('app_icon');

//     var initializationSettingsIOS = DarwinInitializationSettings(

//       requestAlertPermission: true,

//       requestBadgePermission: true,

//       requestSoundPermission: true,

//     );

//     var initializationSettings = InitializationSettings(

//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

//     flutterLocalNotificationsPlugin.initialize(

//       initializationSettings,

//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,

//     );

//   }

//   // Update the callback method to match the expected signature

//   void onDidReceiveNotificationResponse(

//       NotificationResponse notificationResponse) {

//     // Handle your notification selected action here

//     // Since NotificationResponse is not a String, you need to handle it accordingly

//   }

//   Future<void> showNotification(String title, String body) async {

//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(

//       'channel_ID',

//       'channel_name',

//       importance: Importance.max,

//       priority: Priority.high,

//     );

//     var iOSPlatformChannelSpecifics = DarwinNotificationDetails();

//     var platformChannelSpecifics = NotificationDetails(

//         android: androidPlatformChannelSpecifics,

//         iOS: iOSPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(

//       0,

//       title,

//       body,

//       platformChannelSpecifics,

//     );

//   }

//   Future<void> showNotificationWithCustomMessage(

//       String title, String body) async {

//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(

//       'channel_ID',

//       'channel_name',

//       importance: Importance.max,

//       priority: Priority.high,

//     );

//     var iOSPlatformChannelSpecifics = DarwinNotificationDetails();

//     var platformChannelSpecifics = NotificationDetails(

//         android: androidPlatformChannelSpecifics,

//         iOS: iOSPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(

//       0,

//       title,

//       body,

//       platformChannelSpecifics,

//     );

//   }

// }

import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHandler {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotificationHandler() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_ID',

      'channel_name',

      // 'channel_description',

      importance: Importance.max,

      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> onDidReceiveNotificationResponse(
      NotificationResponse? response) async {
    if (response?.payload != null) {
      debugPrint('Notification payload: ${response?.payload}');
    }

    // Navigate to a particular screen when the notification is tapped

    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => YourScreen()));
  }
}
