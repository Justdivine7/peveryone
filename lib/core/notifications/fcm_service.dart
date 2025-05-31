// https://firebase.google.com/docs/cloud-messaging/flutter/client

import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:peveryone/core/notifications/token_manager.dart';
import 'package:peveryone/core/notifications/user_manager.dart';
import 'package:peveryone/main.dart';
import 'package:peveryone/presentation/screens/chat/views/chat_room.dart';

class AppNotify {
  static Future<void> handleNotifications(RemoteMessage msg) async {
    log('Background msg received: ${msg.messageId}');
  }

  final fcm = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_important_channel',
    'High Important Notifications',
    description: 'This Channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final localNotify = FlutterLocalNotificationsPlugin();
  int notifyCount = 0;

  Future<void> _incrementCount() async {
    notifyCount++;
    await UserManager.saveNotificationCount(notifyCount);
  }

  Future<void> _decrementCount() async {
    if (notifyCount > 0) {
      notifyCount--;
      await UserManager.saveNotificationCount(notifyCount);
    }
  }

  void msgHandler(RemoteMessage? message) {
    if (message == null) return;
    final data = message.data;
    navigatorKey.currentState?.pushNamed(
      ChatRoom.routeName,
      arguments: {
        'senderId': data['senderId'],
        'receiverId': data['receiverId'],
        'firstName': data['firstName'],
      },
    );
  }

  Future initPush() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if (msg != null) {
        _decrementCount();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(msgHandler);
    FirebaseMessaging.onBackgroundMessage(handleNotifications);

    FirebaseMessaging.onMessage.listen((message) {
      final notifications = message.notification;
      if (notifications == null) return;

      _incrementCount();

      localNotify.show(
        notifications.hashCode,
        notifications.title,
        notifications.body,
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
    });
  }

  @pragma('vm:entry-point')
  static Future<void> onDidReceiveBackgroundNotificationResponse(
    NotificationResponse notifyResponse,
  ) async {
    final payload = notifyResponse.payload;
    if (payload != null) {
      final message = RemoteMessage.fromMap(jsonDecode(payload));
      handleNotifications(message);
    }
  }

  Future initLocalNotify() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await localNotify.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    final isPlatform =
        localNotify
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await isPlatform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotifications() async {
    await fcm.requestPermission();
    final fcmToken = await fcm.getToken();
    await TokenManager.fcmToken(fcmToken ?? '');

    log('TOKEN: $fcmToken');
    initPush();
    initLocalNotify();
  }
}
