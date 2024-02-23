
import 'package:get/get.dart';

import 'ui/core_controller.dart';


final class CoreBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoreController>(
      () => CoreController(),
    );
  }
}
