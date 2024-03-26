import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

import '../../../app_widget.dart';
import '../services/core_module_services.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    try {
      Logger().i(task);
      await initServices();
      runApp(
        const AppWidget(),
      );
      Logger().i("Run app restart");

      //-------------------Firebase------------------
    } catch (err) {
      Logger().e(err.toString());
      throw Exception(err);
    }

    return true; //If True returned that means task is successfully completed.
  });
}
