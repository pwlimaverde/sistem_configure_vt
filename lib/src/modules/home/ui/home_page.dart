import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/core_controller.dart';

final class HomePage extends GetView<CoreController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(backgroundColor: Colors.white,),
        ),
      ),
    );
  }
}
