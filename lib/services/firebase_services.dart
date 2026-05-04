import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../features/home/presentation/controllers/home_controller.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Permission
    await _firebaseMessaging.requestPermission();

    // Token
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    final controller = Get.find<HomeController>();

    // Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "No Title";
      final body = message.notification?.body ?? "No Body";

      print("Foreground Message: $title");

      // 🔥 Send data to controller
      controller.addNotification(title, body);
    });

    // Background click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification Clicked");
    });
  }
}