import 'dart:io';

import 'package:android_power_manager/android_power_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    print("status: $status");
    if (status.isGranted) {
      print(
          "isIgnoring: ${(await AndroidPowerManager.isIgnoringBatteryOptimizations)}");
      if (!(await AndroidPowerManager.isIgnoringBatteryOptimizations)!) {
        AndroidPowerManager.requestIgnoreBatteryOptimizations();
      }
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.ignoreBatteryOptimizations,
      ].request();
      print(
          "permission value: ${statuses[Permission.ignoreBatteryOptimizations]}");
      if (statuses[Permission.ignoreBatteryOptimizations]!.isGranted) {
        AndroidPowerManager.requestIgnoreBatteryOptimizations();
      } else {
        exit(0);
      }
    }
  }


