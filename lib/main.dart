import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:my_sip/my_app.dart';
import 'package:my_sip/services/session_manager.dart';

import 'core/utils/helper/helpers.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) {
      usePathUrlStrategy();
    }

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (!kIsWeb) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    await Get.putAsync<SessionManager>(() async {
      final session = SessionManager.instance;
      await session.initialize();
      return session;
    });
    runApp(const MyApp());
  } catch (e, stackTrace) {
    createLog("Error in main initialization: $e");

    createLog("Stack trace: $stackTrace");
    runApp(const MyApp());
  }
}
