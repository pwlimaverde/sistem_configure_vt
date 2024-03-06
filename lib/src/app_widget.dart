import 'dart:io';

import 'package:android_power_manager/android_power_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';


import 'app_module.dart';
import 'modules/core/core_bindings.dart';

final class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    init();
    return GetMaterialApp(
      title: 'App Configuration Android',
      debugShowCheckedModeBanner: false,
      initialBinding: CoreBindings(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: AppModule().routes,
    );
  }
}

void init() async {
    var status = await Permission.ignoreBatteryOptimizations.status;
    var statusAudio = await Permission.microphone.status;
    Logger().i("status: $status");
    Logger().i("statusAudio: $statusAudio");
    
      Map<Permission, PermissionStatus> statuses = await [
        Permission.ignoreBatteryOptimizations,
        Permission.microphone,
      ].request();
      Logger().i(
          "permission value: ${statuses[Permission.ignoreBatteryOptimizations]}");
      if (statuses[Permission.ignoreBatteryOptimizations]!.isGranted) {
        AndroidPowerManager.requestIgnoreBatteryOptimizations();
      } else {
        exit(0);
      }
      Logger().i(
          "permission value: ${statuses[Permission.microphone]}");
      if (statuses[Permission.microphone]!.isGranted) {
        Permission.microphone.request();
      } else {
        exit(0);
      }

    }
  


