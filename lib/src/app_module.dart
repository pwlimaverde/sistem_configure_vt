import 'package:get/get_navigation/src/routes/get_route.dart';



import 'modules/home/home_module.dart';
import 'utils/module.dart';

final class AppModule implements Module {
  @override
  List<GetPage> routes = [
    ...HomeModule().routes,
  ];
}
