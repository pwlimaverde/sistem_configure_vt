import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'src/app_widget.dart';
import 'src/app_widget_animation.dart';
import 'src/modules/core/foreground/back_services.dart';
import 'src/modules/core/services/core_module_services.dart';
import 'src/modules/core/work/workmanage_callback.dart';

void main() async {
  runApp(
    const AppWidgetAnimation(),
  );
  await Workmanager().initialize(
    callbackDispatcher,
  );
  await initServices();
  await initializeServiceBack();
  runApp(
    const AppWidget(),
  );
}
