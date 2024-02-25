import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_module.dart';
import 'modules/core/core_bindings.dart';

final class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'App Configuration Android',
      debugShowCheckedModeBanner: false,
      initialBinding: CoreBindings(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: AppModule().routes,
    );
  }
}
