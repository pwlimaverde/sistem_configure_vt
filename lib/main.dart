import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'src/app_widget.dart';
import 'src/app_widget_animation.dart';
import 'src/modules/core/foreground/back_services.dart';
import 'src/modules/core/service/core_module_services.dart';
import 'src/modules/core/service/start_services.dart';

void main() async {
  runApp(
    const AppWidgetAnimation(),
  );
  // await Workmanager().initialize(
  //   callbackDispatcher,
  // );
  await startServices();
  await initServices();
  await initializeServiceBack();
  FlutterBackgroundService().invoke('setAsForeground');
  runApp(
    const AppWidget(),
  );
  
}
