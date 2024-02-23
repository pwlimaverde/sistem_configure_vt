import 'package:get/get_navigation/src/routes/get_route.dart';

import 'modules/core/core_module.dart';

import 'utils/module.dart';

final class AppModule implements Module {
  @override
  List<GetPage> routes = [
    ...CoreModule().routes,
  ];
}
