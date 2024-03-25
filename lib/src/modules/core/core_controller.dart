import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:return_success_or_error/return_success_or_error.dart';
import 'package:workmanager/workmanager.dart';

import 'features/features_core_presenter.dart';

final class CoreController extends GetxController {
  final FeaturesCorePresenter featuresCorePresenter;

  CoreController({required this.featuresCorePresenter});

  @override
  void onInit() async {
    super.onInit();
    _carregarConfiguracao();
    _carregarTimes();
    _config.listen((value) {
      if (value != null) {
        licenca(value['licenca']);
      }
      readAndWriteFirebaseData();
    });

    // await Workmanager().cancelAll();
    _registerPeriodicTask();
  }

  var plataform = const MethodChannel('method.record');

  final licenca = Rxn<bool>();

  //Configuração Sufixo
  final _config = Rxn<Map<String, dynamic>>();

  String? get config => _config.value.toString();

  final _times = Rxn<List<Map<String, dynamic>>>();

  List<String>? get times {
    _times.value?.sort((a, b) => a['road'].compareTo(b['road']));
    final list = _times.value
        ?.map((e) => (DateTime.fromMillisecondsSinceEpoch(int.parse(
                (e['road'] as Timestamp).millisecondsSinceEpoch.toString())))
            .toString())
        .toList();
    return list;
  }

  Future<void> _carregarConfiguracao() async {
    final result = await featuresCorePresenter.carregarConfiguracaoFirebase(
      NoParams(),
    );
    if (result != null) {
      _config.bindStream(result);
    }
  }

  Future<void> _carregarTimes() async {
    final result = await featuresCorePresenter.registerTime(
      NoParams(),
    );
    if (result != null) {
      _times.bindStream(result);
    }
  }

  void setTime() {
    if (licenca.value != null) {
      licenca.listen((value) async {
        while (licenca.value!) {
          final road = _config.value?['time_start'] ?? 600;
          await Future.delayed(Duration(seconds: road));
          FirebaseFirestore.instance
              .collection("comandos")
              .doc("time")
              .collection("register")
              .doc()
              .set({'road': DateTime.now()});
        }
      });
    }
  }

  Future<void> _registerPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      "task2",
      "PeriodicTask",
      tag: "2",
      frequency: const Duration(minutes: 15),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      initialDelay: const Duration(seconds: 30),
      constraints: Constraints(networkType: NetworkType.connected),
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(seconds: 10),
      inputData: _config.value,
    );
  }

  Future<String> plataformInit() async {
    final method = await plataform.invokeMethod('onInit');
    Logger().i('MethodChannel result$method');
    return method;
  }

  Future<String> plataformStart() async {
    final method = await plataform.invokeMethod('onStart');
    Logger().i('MethodChannel result$method');
    return method;
  }

  Future<String> plataformStop() async {
    final method = await plataform.invokeMethod('onStop');
    Logger().i('MethodChannel result$method');
    return method;
  }

  Future<void> readAndWriteFirebaseData() async {
    final init = await plataformInit();
    Logger().i('MethodChannel result$init');
    Logger().i('firebase conect...');
    final docData =
        FirebaseFirestore.instance.collection("configuracao").doc("options");
    final snapshot = await docData.get();
    Logger().i('firebase conected - ${snapshot.data()}');

    if (snapshot.exists) {
      final int time = snapshot.data()!['time_start'] ?? 15;
      final bool licenca = snapshot.data()!['licenca'] ?? false;
      if (licenca) {
        bool repeat = true;
        while (repeat == true) {
          final start = await plataformStart();
          Logger().i('Record start MethodChannel result$start');

          await Future.delayed(Duration(minutes: time));

          final path = await plataformStop();
          Logger().i('Stop recording $path');
          if (path.isNotEmpty) {
            Logger().i('Inicio Uploade FirebaseStorage');
            await upload(path);
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

          final docData = FirebaseFirestore.instance
              .collection("configuracao")
              .doc("options");
          final snapshot = await docData.get();
          repeat = snapshot.data()!['licenca'] ?? false;
          if (!repeat) {
            Logger().i('Service Stoped}');
          }
        }
      }
    }
  }

  Future<void> upload(String path) async {
    File file = File(path);

    try {
      String ref = 'record/rec-${DateTime.now().toString()}.mp3';
      await FirebaseStorage.instance.ref(ref).putFile(file);
      file.delete();
    } catch (e) {
      Logger().e('erro no uploa');
    }
  }
}