import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../utils/routes.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: IconButton(
              onPressed: () {
                controller.signInGoogleLogin(
                    onSuccess: () {
                      Get.snackbar(
                        "Bem vindo",
                        'Login efetuado com sucesso',
                        icon: const Icon(FontAwesomeIcons.check),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      Future.delayed(const Duration(seconds: 2)).then((_) {
                        Get.offAllNamed(Routes.initial.caminho);
                      });
                    },
                    onFail: () {
                      Get.snackbar(
                        'Olá',
                        'Não foi possível fazer o login',
                        icon: const Icon(FontAwesomeIcons.faceMeh),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  );
              }, icon: const FaIcon(FontAwesomeIcons.google)),
        ),
      ),
    );
  }
}
