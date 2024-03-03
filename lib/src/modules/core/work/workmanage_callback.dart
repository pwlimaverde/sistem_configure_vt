import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

import '../services/core_module_services.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> callbackDispatcher() async {
  await initServices();

  Workmanager().executeTask((task, inputData) async {
    try {
      Logger().i(task);
      Logger().i(inputData);
      //   //--------------SharedPreferences--------------
      // final prefs = Get.find<GetStorage>();

      // prefs.write('value', 100);

      // final int? value = prefs.read('value');

      // Logger().i("GetStorage value = $value");

      if (inputData != null) {
        final bool licenca = inputData['licenca'];
        Logger().i('Teste Licença $licenca');

        //-------------------Firebase-------------------
        final dataFromFirebase = await readAndWriteFirebaseData(licenca);
        if (dataFromFirebase != null) {
          print("Firebase Data1 = ${dataFromFirebase.data1}");
          print("Firebase Data2 = ${dataFromFirebase.data2}");
          print("Firebase Data3 = ${dataFromFirebase.data3}");
          print("Firebase Data4 = ${dataFromFirebase.data4}");
        } else {
          return false; //If False returned that means task is failed and will be retry.
        }
      }
    } catch (err) {
      Logger().e(err.toString());
      throw Exception(err);
    }

    return true; //If True returned that means task is successfully completed.
  });
}

//Read data from firebase
Future<FirebaseModel?> readAndWriteFirebaseData(bool licenca) async {
  // Fetch from Firebase
  final docData = FirebaseFirestore.instance.collection("example").doc("value");
  final snapshot = await docData.get();

  while (licenca == true) {
    await Future.delayed(const Duration(seconds: 180));

    FirebaseFirestore.instance
        .collection("comandos")
        .doc("time")
        .collection("register")
        .doc()
        .set({'road': DateTime.now()});
  }

  if (snapshot.exists) {
    return FirebaseModel.fromJson(snapshot.data()!);
  } else {
    return null;
  }
}

class FirebaseModel {
  final int? data1;
  final bool? data2;
  final String? data3;
  final String? data4;

  FirebaseModel({
    required this.data1,
    required this.data2,
    required this.data3,
    required this.data4,
  });

  Map<String, dynamic> toJson() => {
        "data1": data1,
        "data2": data2,
        "data3": data3,
        "data4": data4,
      };
  static FirebaseModel fromJson(Map<String, dynamic> json) => FirebaseModel(
        data1: json["Data1"] as int?,
        data2: json["Data2"] as bool?,
        data3: json["Data3"] as String?,
        data4: json["Data4"] as String?,
      );
}
