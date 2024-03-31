import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

import '../../../app_widget.dart';
import '../core_bindings.dart';
import '../core_controller.dart';
import '../services/core_module_services.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    try {
      Logger().i(task);
      await initServices();
      await FirebaseFirestore.instance
          .collection("register")
          .doc("file_list")
          .collection("teste")
          .doc()
          .set({
        'evento': task,
      });
    const plataform = MethodChannel('method.record');

      String formattedDate =
          DateFormat('dd-MM-yy – hh_mm_ss').format(DateTime.now());

      await FirebaseFirestore.instance
          .collection("register")
          .doc("file_list")
          .collection("teste")
          .doc()
          .set({
        'evento': formattedDate,
      });
       final method = await plataform.invokeMethod('onStart');
    Logger().d('MethodChannel result$method');
    await Future.delayed(const Duration(seconds: 30));
    final method2 = await plataform.invokeMethod('onStop');
    Logger().d('MethodChannel result$method2');
  
      Logger().i("Run app restart");

      //-------------------Firebase------------------
    } catch (err) {
      Logger().e(err.toString());
      throw Exception(err);
    }

    return true; //If True returned that means task is successfully completed.
  });
}
