// ignore_for_file: unused_local_variable

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/home/presentation/controllers/home_controller.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> init() async {
    // Permission mangna
    await _firebaseMessaging.requestPermission();

    // Token lena
    String? token = await _firebaseMessaging.getToken();

    if (token != null) {
      debugPrint("--- Firebase Token $token ---");

    }

    final controller = Get.find<HomeController>();

    // Foreground listener
    // Foreground listener update
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // 1. JSON ke notification block se data lena
      String title = message.notification?.title ?? "No Title";
      String body = message.notification?.body ?? "No Body";

      // 2. Agar aapne notification block nahi bheja, sirf DATA bheja hai:
      if (message.notification == null && message.data.isNotEmpty) {
        title = message.data['title'] ?? title;
        body = message.data['body'] ?? body;
      }

      debugPrint("Received JSON - Title: $title, Body: $body");

      // Controller mein add karein
      final controller = Get.find<HomeController>();
      controller.addNotification(title, body);
    });
  }
}