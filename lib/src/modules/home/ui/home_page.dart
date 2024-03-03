import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/core_controller.dart';

final class HomePage extends GetView<CoreController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Obx(
                () => Text(
                  controller.config == null
                      ? "carregando!"
                      : controller.config.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Obx(
                () => controller.times != null?SizedBox(
                  width: 500,
                  height: 500,
                  child: ListView.builder(
                    itemCount: controller.times?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(controller.times![index]),
                      );
                    },
                  ),
                ):Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
