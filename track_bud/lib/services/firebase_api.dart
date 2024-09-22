import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  final GlobalKey<NavigatorState>? navigatorKey;

  FirebaseApi({this.navigatorKey});

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // Handle the notification tap without showing another notification
    debugPrint('Notification received: ${message.notification?.title}');
    // You can also navigate to a screen using navigatorKey, e.g.,
    // navigatorKey?.currentState?.pushNamed(DebtsScreen.route, arguments: message);
  }

  Future<void> initLocalNotifications() async {
    try {
      const ios = DarwinInitializationSettings();
      const android = AndroidInitializationSettings('@drawable/ic_launcher');
      const settings = InitializationSettings(android: android, iOS: ios);

      await _localNotifications.initialize(
        settings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
          final message =
              RemoteMessage.fromMap(jsonDecode(notificationResponse.payload!));
          handleMessage(message);
        },
      );

      final platform =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await platform?.createNotificationChannel(_androidChannel);
    } catch (e) {
      debugPrint('Error initializing local notifications: $e');
    }
  }

  Future<void> initPushNotifications() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Handle notification when the app is opened from a terminated state
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          // Only handle the message, no need to show another notification
          handleMessage(message);
        }
      });

      // Handle notification when the app is opened from the background
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        // Handle the message without showing a notification
        handleMessage(message);
      });

      // Handle notification when the app is in the foreground (local notifications only here)
      FirebaseMessaging.onMessage.listen((message) {
        if (message.notification != null) {
          // Show a local notification only when the app is in the foreground
          _localNotifications.show(
            message.hashCode,
            message.notification?.title,
            message.notification?.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: '@drawable/ic_launcher',
              ),
            ),
            payload: jsonEncode(message.toMap()),
          );
        }
      });

      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    } catch (e) {
      debugPrint('Error initializing push notifications: $e');
    }
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    debugPrint('Token: $fCMToken');

    initPushNotifications();
    initLocalNotifications();
  }
}
