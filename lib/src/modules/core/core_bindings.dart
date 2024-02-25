
import 'package:get/get.dart';

import 'core_controller.dart';


final class CoreBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<CoreController>(
      CoreController(),
      permanent: true,
    );
  }
}
