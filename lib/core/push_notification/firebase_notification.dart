import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/download_image.dart';

class LocalNotificationClass {
  LocalNotificationClass._();

  // Singleton instance
  static final LocalNotificationClass _instance = LocalNotificationClass._();

  factory LocalNotificationClass() {
    return _instance;
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initializeLocalNotification() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('ic_stat_circle_notifications');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void showLocalNotification(RemoteMessage message) async {
    final String bigPicturePath = await downloadAndSaveFile(message.data["imageUrl"], 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath), largeIcon: FilePathAndroidBitmap(bigPicturePath));

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'testID',
      'testChannel',
      channelDescription: 'Test channel',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      largeIcon: bigPictureStyleInformation.largeIcon,
      styleInformation: bigPictureStyleInformation,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(1000), // Notification ID
      message.notification!.title, // Notification title
      message.notification!.body, // Notification body
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }
}

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeFirebaseMessaging() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    _firebaseMessaging.subscribeToTopic("TEST");
    LocalNotificationClass().initializeLocalNotification();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationClass().showLocalNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }
}
