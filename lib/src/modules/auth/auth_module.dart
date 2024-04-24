import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../utils/module.dart';
import '../../utils/routes.dart';
import 'ui/login/login_page.dart';
final class AuthModule implements Module {
  @override
  List<GetPage> routes = [
    GetPage(
      name: Routes.initial.caminho,
      page: () => const LoginPage(),
    )
  ];
}
