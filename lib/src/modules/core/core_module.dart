import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../utils/module.dart';
import '../../utils/routes.dart';
import 'core_bindings.dart';
import 'ui/core_page.dart';

final class CoreModule implements Module {
  @override
  List<GetPage> routes = [
    GetPage(
      name: Routes.initial.caminho,
      page: () => const CorePage(),
      bindings: [
        CoreBindings(),
      ],
    )
  ];
}
