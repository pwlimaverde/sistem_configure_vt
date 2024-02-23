import 'package:flutter/material.dart';

import 'src/app_widget.dart';
import 'src/app_widget_animation.dart';
import 'src/modules/core/services/core_module_services.dart';

void main() async {
  runApp(
    const AppWidgetAnimation(),
  );
  await initServices();
  runApp(
    const AppWidget(),
  );
}
