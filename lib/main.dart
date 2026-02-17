import 'package:flutter/material.dart';
import 'package:my_sip/my_app.dart';
import 'package:my_sip/services/session_manager.dart';

import 'core/utils/helper/helpers.dart';

Future<void> main() async {

  // await SessionManager.instance.initialize();

  try {

    WidgetsFlutterBinding.ensureInitialized();
    await SessionManager.instance.initialize();
    runApp(const MyApp());
  } catch (e, stackTrace) {
    createLog("Error in main initialization: $e");
    createLog("Stack trace: $stackTrace");
    runApp(const MyApp());
  }
}
