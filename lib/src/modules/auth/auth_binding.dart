import 'package:get/get.dart';

import 'ui/login/login_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(
      LoginController(),
      permanent: true,
    );
  }
}
