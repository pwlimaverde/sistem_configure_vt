import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'service/firebase/firebase_service.dart';
import 'service/widgets_flutter_binding/widgets_flutter_binding_service.dart';

Future<void> initServices() async {
  await Future.wait([
    Get.putAsync<WidgetsBinding>(
      () => WidgetsFlutterBindingService().init(),
      permanent: true,
    ),
    Get.putAsync<FirebaseApp>(
      () => FirebaseService().init(),
      permanent: true,
    ),
  ]);
}
