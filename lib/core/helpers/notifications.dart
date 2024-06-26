import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

abstract class Notifications {
  static Future initilization(
    FlutterLocalNotificationsPlugin localNotifications,
  ) async {
    var androidInitialization = const AndroidInitializationSettings(
      'mipmap/ic_launcher',
    );
    var iosInitialization = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitialization,
      iOS: iosInitialization,
    );

    await localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        if (details.payload != null) {
          await OpenFile.open(details.payload);
        }
      },
    );
  }

  static Future showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    required FlutterLocalNotificationsPlugin localNotifications,
  }) async {
    var androidNotificationDetails = const AndroidNotificationDetails(
      'dinar-id',
      'dinar-notification',
      playSound: true,
      enableVibration: true,
      importance: Importance.high,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future showDownloadNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    required FlutterLocalNotificationsPlugin localNotifications,
  }) async {
    var androidNotificationDetails = AndroidNotificationDetails(
      'dinar-id',
      'dinar-notification',
      playSound: false,
      enableVibration: false,
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
    );

    var notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) async {
      Notifications.showNotification(
          id: DateTime.now().millisecondsSinceEpoch % 0x7FFFFFFF,
          title: message.notification!.title!,
          body: message.notification!.body!,
          localNotifications: FlutterLocalNotificationsPlugin());
    },
  );
}
