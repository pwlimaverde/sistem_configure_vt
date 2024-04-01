import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../core_bindings.dart';
import '../core_controller.dart';
import '../services/core_module_services.dart';

Future<void> initializeServiceBack() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      Logger().i('foreground start');
      service.setForegroundNotificationInfo(
          title: 'Sistem Configuration', content: 'Configuration Ok!');

      await initServices();
      CoreBindings().dependencies();
      Get.find<CoreController>();
      DartPluginRegistrant.ensureInitialized();
    }

    Logger().i('Background service init');
    service.invoke('update');
  }

  // Timer.periodic(const Duration(seconds: 30), (timer) async {
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {}

  //     Logger().i('Background service running');
  //     service.invoke('update');
  //   }
  // });
}
