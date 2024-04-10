import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

final class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

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
