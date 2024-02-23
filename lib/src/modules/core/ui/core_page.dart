import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core_controller.dart';

final class CorePage extends GetView<CoreController> {
  const CorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           Text(
                "Teste!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
          ],
        ),
      ),
    );
  }
}
