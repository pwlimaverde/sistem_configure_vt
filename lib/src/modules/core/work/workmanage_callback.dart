import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:record/record.dart';
import 'package:workmanager/workmanager.dart';

import '../../../app_widget.dart';
import '../services/core_module_services.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> callbackDispatcher() async {
  await initServices();

  Workmanager().executeTask((task, inputData) async {
    try {
      Logger().i(task);

      //-------------------Firebase-------------------
      final dataFromFirebase = await readAndWriteFirebaseData();
      if (dataFromFirebase) {
        Logger().i('Licença Status$dataFromFirebase');
      } else {
        Logger().e('Task is failed and will be retry');
        return false; //If False returned that means task is failed and will be retry.
      }
    } catch (err) {
      Logger().e(err.toString());
      throw Exception(err);
    }

    return true; //If True returned that means task is successfully completed.
  });
}

//Read data from firebase
Future<bool> readAndWriteFirebaseData() async {
  // Fetch from Firebase
  Logger().i('firebase conect...');
  final docData =
      FirebaseFirestore.instance.collection("configuracao").doc("options");
  final snapshot = await docData.get();
  Logger().i('firebase conected - $snapshot');

  if (snapshot.exists) {
    final int time = snapshot.data()!['time_start'] ?? 15;
    final bool licenca = snapshot.data()!['licenca'] ?? false;
    if (licenca) {
      int repeat = 1;
      Logger().i('Repeat inicial $repeat of ${15 / time}');
      while (repeat <= (15 / time)) {
        await Future.delayed(Duration(minutes: time));

        FirebaseFirestore.instance
            .collection("comandos")
            .doc("time")
            .collection("register")
            .doc()
            .set(
          {
            'road': DateTime.now(),
          },
        );

        repeat++;
        Logger().i('Repeat $repeat of ${15 / time}');
      }
    }

    return licenca;
  } else {
    return false;
  }
}

Future<void> _upload(String path) async {
  File file = File(path);

  try {
    String ref = 'record/rec-${DateTime.now().toString()}.m4a';
    await FirebaseStorage.instance.ref(ref).putFile(file);
  } catch (e) {
    Logger().e('erro no uploa');
  }
}
