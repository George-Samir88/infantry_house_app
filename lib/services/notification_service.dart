import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  /// 🔹 Default Android notification channel
  static const AndroidNotificationChannel _defaultChannel =
  AndroidNotificationChannel(
    'default_channel_id',
    'General Notifications',
    description: 'Used for all app notifications',
    importance: Importance.high,
  );

  /// 🔹 Initialize Firebase Messaging + Local Notifications
  static Future<void> init() async {
    await _initLocalNotifications();
    await _initFirebaseMessaging();
  }

  /// 🔹 Initialize local notifications
  static Future<void> _initLocalNotifications() async {
    const androidInit =
    AndroidInitializationSettings('@drawable/ic_stat_notification');
    const initSettings = InitializationSettings(android: androidInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          log("🚀 Notification tapped with payload: ${response.payload}");
          // TODO: Add navigation logic here if needed
        }
      },
    );

    // Create default channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_defaultChannel);
  }

  /// 🔹 Initialize Firebase Messaging listeners
  static Future<void> _initFirebaseMessaging() async {
    await _messaging.requestPermission();

    await _messaging.subscribeToTopic('all');
    log("✅ Subscribed to topic: all");

    final token = await _messaging.getToken();
    log("📱 FCM Token: $token");

    // Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    // Background or terminated open
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("🚀 App opened from background: ${message.data}");
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        log("💡 App opened from terminated: ${message.data}");
      }
    });
  }

  /// 🔹 Display notification with image or expandable text
  static Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final imageUrl = message.data['image'] ?? notification.android?.imageUrl;

    BigPictureStyleInformation? bigPictureStyle;
    StyleInformation? style;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Try to download and display the image
      try {
        final filePath = await _downloadAndSaveFile(imageUrl, 'bigPicture');
        bigPictureStyle = BigPictureStyleInformation(
          FilePathAndroidBitmap(filePath),
          contentTitle: notification.title,
          summaryText: notification.body,
        );
        style = bigPictureStyle;
      } catch (e) {
        log("⚠️ Error loading image for notification: $e");
        style = BigTextStyleInformation(notification.body ?? '');
      }
    } else {
      // Long text notification if no image
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
      payload: message.data.toString(),
    );
  }

  /// 🔹 Download and save image for BigPictureStyle
  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  /// 🔹 Background message handler
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    log("🔹 Background message: ${message.notification?.title}");
  }
}
