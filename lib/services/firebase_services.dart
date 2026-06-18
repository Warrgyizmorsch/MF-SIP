// ignore_for_file: unused_local_variable

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/home/presentation/controllers/home_controller.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> init() async {
    await _firebaseMessaging.requestPermission();

    // Token lena
    String? token = await _firebaseMessaging.getToken();

    if (token != null) {
      debugPrint("--- Firebase Token $token ---");

    }

    final controller = Get.find<HomeController>();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String title = message.notification?.title ?? "No Title";
      String body = message.notification?.body ?? "No Body";

      if (message.notification == null && message.data.isNotEmpty) {
        title = message.data['title'] ?? title;
        body = message.data['body'] ?? body;
      }

      debugPrint("Received JSON - Title: $title, Body: $body");

      final controller = Get.find<HomeController>();
      controller.addNotification(title, body);
    });
  }
}