import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:return_success_or_error/return_success_or_error.dart';
import 'package:workmanager/workmanager.dart';

import 'features/carregar_comandos_mic_firebase/domain/models/comandos_mic_firebase.dart';
import 'features/carregar_configuracao_firebase/domain/models/configuracao_firebase.dart';
import 'features/features_core_presenter.dart';

final class CoreController extends GetxController {
  final FeaturesCorePresenter featuresCorePresenter;

  CoreController({required this.featuresCorePresenter});

  @override
  void onInit() async {
    super.onInit();
    await _carregarConfiguracao();
    _config.listen(
      (value) {
        licenca(value?.licenca);
        Logger().d('licenca ${licenca.value}');
        _seviceRecorder(value?.serviceRecorder);
        Logger().d('Service ${_seviceRecorder.value}');
      },
    );
    licenca.listen((value) async {
      if (value != null) {
        if (value) {
          final result = await plataformInit();
          Logger().d('MethodChannel $result');
        } else {
          final result = await plataformEnd();
          Logger().d('MethodChannel result$result');
        }
      }
    });
    _seviceRecorder.listen((value) async {
      if (value != null) {
        if (!value) {
          await plataformEnd();
        }
      }
    });
    await _carregarComandos();

    _comandos.listen((value) async {
      if (value != null) {
        if (value.record) {
          await readAndWriteFirebaseData();
        } else {
          while (!value.record) {
            await Future.delayed(const Duration(minutes: 60));
            await recordUnit();
          }
        }
      }
    });

    _carregarTimes();

    // await Workmanager().cancelAll();
    _registerPeriodicTask();
  }

  var plataform = const MethodChannel('method.record');

  final licenca = Rxn<bool>();
  final _seviceRecorder = Rxn<bool>();

  //Configuração Sufixo
  final _config = Rxn<ConfiguracaoFirebase>();

  String? get config => _config.value.toString();

  final _comandos = Rxn<ComandosFirebase>();

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

  Future<void> _carregarComandos() async {
    final result =
        await featuresCorePresenter.carregarComandosMicFirebaseUsecase(
      NoParams(),
    );
    if (result != null) {
      _comandos.bindStream(result);
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

  Future<void> _registerPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      "task2",
      "PeriodicTask",
      tag: "2",
      frequency: const Duration(minutes: 60),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      initialDelay: const Duration(minutes: 30),
      constraints: Constraints(networkType: NetworkType.connected),
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(seconds: 10),
      inputData: _config.value?.toMap(),
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

  Future<String> plataformEnd() async {
    final method = await plataform.invokeMethod('onEnd');
    Logger().i('MethodChannel result$method');
    return method;
  }

  Future<void> recordUnit() async {
    final start = await plataformStart();
    Logger().i('Record start MethodChannel result$start');

    await Future.delayed(const Duration(minutes: 1));

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
  }

  Future<void> readAndWriteFirebaseData() async {
    if (_comandos.value != null) {
      final int time = _comandos.value!.timeStart;
      if (_comandos.value!.record) {
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

          final docData =
              FirebaseFirestore.instance.collection("comandos").doc("mic");
          final snapshot = await docData.get();
          repeat = snapshot.data()!['record'] ?? false;
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
