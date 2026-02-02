import 'package:flutter/material.dart';
import 'package:my_sip/my_app.dart';

import 'core/utils/helper/helpers.dart';

Future<void> main() async {
  try {

    // await SessionManager.instance.getSession();

    runApp(const MyApp());
  } catch (e, stackTrace) {
    createLog("Error in main initialization: $e");
    createLog("Stack trace: $stackTrace");
    runApp(const MyApp());
  }
}
