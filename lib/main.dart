import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:simple_login/screens/login.dart';
import 'package:simple_login/config/theme/custom_theme.dart';

import 'core/push_notification/firebase_notification.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // LocalNotificationClass().showLocalNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessagingService().initializeFirebaseMessaging();

  runApp(MaterialApp(
    theme: CustomTheme.themeData,
    debugShowCheckedModeBanner: false,
    home: const Scaffold(
      body: Login(),
    ),
  ));
}
