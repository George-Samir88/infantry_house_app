import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../main.dart';

/// 🔹 Refactored Notification Service for FCM + Local Notifications
class NotificationService {
  // Firebase Messaging instance
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Local Notifications plugin
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  // Default Android notification channel
  static const AndroidNotificationChannel _defaultChannel =
  AndroidNotificationChannel(
    'default_channel_id',
    'General Notifications',
    description: 'Used for all app notifications',
    importance: Importance.high,
  );

  /// Initialize FCM & Local Notifications
  static Future<void> init() async {
    await _initLocalNotifications();
    await _initFirebaseMessaging();
  }

  /// Initialize Local Notifications
  static Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings(
      '@drawable/ic_stat_notification',
    );

    const initSettings = InitializationSettings(android: androidInit);

    // Capture notification taps
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          log("🚀 Notification tapped: ${response.payload}");
          handleNotificationClick(response.payload!);
        }
      },
    );

    // Create default channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_defaultChannel);
  }

  /// Handle notification click navigation
  static void handleNotificationClick(String payload) {
    try {
      if (payload == 'alert') {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/notifications',
              (route) => route.isFirst,
        );
      } else if (payload == 'notification' || payload.startsWith('/offer')) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/notifications',
              (route) => route.isFirst,
        );
      } else {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/notifications',
              (route) => route.isFirst,
        );
      }
    } catch (e) {
      log('⚠️ Navigation error: $e');
    }
  }

  /// Initialize Firebase Messaging listeners
  static Future<void> _initFirebaseMessaging() async {
    await _messaging.requestPermission();
    await _messaging.subscribeToTopic('all');
    log("✅ Subscribed to topic: all");

    final token = await _messaging.getToken();
    log("📱 FCM Token: $token");

    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) => _showNotification(message));

    // Background / App opened from terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final route = message.data['route'];
      if (route != null) handleNotificationClick(route);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final route = message.data['route'];
        if (route != null) handleNotificationClick(route);
      }
    });
  }

  /// Display notification (image or expandable text)
  static Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final imageUrl = message.data['image'] ?? notification.android?.imageUrl;

    BigPictureStyleInformation? bigPictureStyle;
    StyleInformation? style;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final filePath = await _downloadAndSaveFile(imageUrl, 'bigPicture');
        bigPictureStyle = BigPictureStyleInformation(
          FilePathAndroidBitmap(filePath),
          contentTitle: notification.title,
          summaryText: notification.body,
        );
        style = bigPictureStyle;
      } catch (e) {
        log("⚠️ Error loading image: $e");
        style = BigTextStyleInformation(notification.body ?? '');
      }
    } else {
      style = BigTextStyleInformation(
        notification.body ?? '',
        contentTitle: notification.title ?? '',
      );
    }

    final androidDetails = AndroidNotificationDetails(
      _defaultChannel.id,
      _defaultChannel.name,
      channelDescription: _defaultChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      color: const Color(0xFF1565C0),
      icon: '@drawable/ic_stat_notification',
      styleInformation: style,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(android: androidDetails),
      payload: message.data['route'] ?? message.data['offerId'] ?? '',
    );
  }

  /// Download and cache image for BigPicture notifications
  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(path);
    await file.writeAsBytes(response.bodyBytes);
    return path;
  }

  /// Background message handler (must be top-level or static)
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    log("🔹 Background message received: ${message.notification?.title}");
  }
}
