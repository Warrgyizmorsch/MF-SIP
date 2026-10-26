import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../core/utils/helper/helpers.dart';
import '../features/authentication/domain/usecases/firebase_token_usecase.dart';
import '../features/home/presentation/controllers/home_controller.dart';
import '../firebase_options.dart';
import 'session_manager.dart';

/// Top-level background message handler for FCM.
/// Must be annotated with `@pragma('vm:entry-point')` so the Flutter engine can locate it in background isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Already initialized or platform issue
  }

  createLog('[FCM Background] Message received: ${message.messageId}');
  if (message.notification != null) {
    createLog('[FCM Background] Notification: ${message.notification?.title} - ${message.notification?.body}');
  }
  if (message.data.isNotEmpty) {
    createLog('[FCM Background] Data payload: ${message.data}');
  }
}

class NotificationService extends GetxService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications and alerts.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  bool _isInitialized = false;

  Future<NotificationService> init() async {
    if (_isInitialized) return this;

    try {
      // 1. Request permission
      await _requestPermissions();

      // 2. Setup Local Notifications (for Android Heads-Up & Foreground alerts)
      if (!kIsWeb) {
        await _setupLocalNotifications();
      }

      // 3. Listen to foreground FCM messages
      _setupForegroundMessageListener();

      // 4. Listen to token refresh
      _setupTokenRefreshListener();

      // 5. Fetch and log current token
      final token = await _fcm.getToken();
      if (token != null) {
        createLog('[FCM] Current Device Token: $token');
      }

      _isInitialized = true;
    } catch (e, stack) {
      createLog('[FCM] Error initializing NotificationService: $e\n$stack');
    }

    return this;
  }

  /// Request notification permission on Android 13+ and iOS
  Future<void> _requestPermissions() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    createLog('[FCM] Permission status: ${settings.authorizationStatus}');

    if (!kIsWeb) {
      // For Android heads-up presentation on foreground
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// Initialize flutter_local_notifications plugin and create Android channel
  Future<void> _setupLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create the high-importance channel on Android
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_channel);
    }
  }

  /// Foreground message handler: display heads-up notification and save to HomeController
  void _setupForegroundMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      createLog('[FCM Foreground] Message received: ${message.messageId}');

      final title = message.notification?.title ??
          message.data['title']?.toString() ??
          'Notification';
      final body = message.notification?.body ??
          message.data['body']?.toString() ??
          '';

      // 1. Store in HomeController notification list if available
      try {
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().addNotification(title, body);
        }
      } catch (e) {
        createLog('[FCM] Failed to store in HomeController: $e');
      }

      // 2. Display local heads-up notification banner if running on Android/iOS
      if (!kIsWeb) {
        _showLocalNotification(message, title, body);
      }
    });
  }

  /// Display a heads-up local banner notification
  Future<void> _showLocalNotification(
    RemoteMessage message,
    String title,
    String body,
  ) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: '@drawable/ic_notification',
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      final notificationId = message.hashCode;
      final payload = jsonEncode(message.data);

      await _localNotifications.show(
        id: notificationId,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } catch (e) {
      createLog('[FCM] Error displaying local notification: $e');
    }
  }

  /// Notification tap callback - will be hooked up to deep linking at the end
  void _onNotificationTap(NotificationResponse response) {
    createLog('[FCM] Notification tapped with payload: ${response.payload}');
    // Deep linking will be connected here in the final deep linking step.
  }

  /// Automatically sync token if it changes
  void _setupTokenRefreshListener() {
    _fcm.onTokenRefresh.listen((newToken) async {
      createLog('[FCM] Device token refreshed: $newToken');
      await syncTokenWithBackend(newToken);
    });
  }

  /// Send device token to backend if user is currently logged in
  Future<void> syncTokenWithBackend([String? token]) async {
    try {
      final authToken = SessionManager.instance.getAccessToken;
      if (authToken == null || authToken.isEmpty) {
        createLog('[FCM] User not logged in, skipping token backend sync');
        return;
      }

      final fcmToken = token ?? await _fcm.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;

      if (Get.isRegistered<FcmDeviceTokenUseCase>()) {
        final useCase = Get.find<FcmDeviceTokenUseCase>();
        final result = await useCase.call({'fcm_token': fcmToken});
        result.fold(
          (success) =>
              createLog('[FCM] Token synced with backend: ${success.data?.message}'),
          (error) =>
              createLog('[FCM] Token backend sync failed: ${error.message}'),
        );
      }
    } catch (e) {
      createLog('[FCM] Error syncing token with backend: $e');
    }
  }

  /// Delete FCM token on user logout
  Future<void> deleteTokenOnLogout() async {
    try {
      createLog('[FCM] Deleting FCM token on logout');
      await _fcm.deleteToken();
    } catch (e) {
      createLog('[FCM] Error deleting FCM token: $e');
    }
  }
}
