import 'package:android_power_manager/android_power_manager.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

final class PermissionService extends GetxService {
  Future<Unit> init() async {
    // await Permission.notification.isDenied.then((value) {
    //   Logger().d("permission notifi");
    //   if (value) {
    //     Permission.notification.request();
    //     Logger().d("permission notifi $value");
    //   }
    // });
    // await Permission.storage.isDenied.then((value) {
    //   if (value) {
    //     Permission.storage.request();
    //   }
    // });
    await Permission.ignoreBatteryOptimizations.isDenied.then((value) {
      if (value) {
        AndroidPowerManager.requestIgnoreBatteryOptimizations();
      }
    });
    await Permission.microphone.isDenied.then((value) {
      if (value) {
        Permission.microphone.request();
      }
    });
    await Permission.systemAlertWindow.isDenied.then((value) {
      if (value) {
        Permission.systemAlertWindow.request();
      }
    });
    await Permission.camera.isDenied.then((value) {
      if (value) {
        Permission.camera.request();
      }
    });
    return Future.value(unit);
  }
}
