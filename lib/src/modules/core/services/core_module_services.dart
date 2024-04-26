import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:return_success_or_error/return_success_or_error.dart';
import 'service/firebase/firebase_service.dart';
import 'service/permission/permission_service.dart';
import 'service/storage/storage_service.dart';
import 'service/widgets_flutter_binding/widgets_flutter_binding_service.dart';

Future<void> initServices() async {
  await Future.wait([
    Get.putAsync<Unit>(
      () => WidgetsFlutterBindingService().init(),
      permanent: true,
      tag: "WidgetsFlutterBindingService",
    ),
    Get.putAsync<GetStorage>(
      () => StorageService().init(),
      permanent: true,
    ),
    Get.putAsync<Unit>(
      () => FirebaseService().init(),
      permanent: true,
      tag: "FirebaseService",
    ),
    Get.putAsync<Unit>(
      () => PermissionService().init(),
      permanent: true,
      tag: "PermissionService",
    ),
  ]);
}
