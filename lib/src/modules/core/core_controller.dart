import 'dart:io';

import 'package:audio_recorder_vt_plugin/audio_recorder_vt_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

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
        _seviceRecorder(value?.serviceRecorder);
        _cleanFiles(value?.cleanFiles);
        _uploadFiles(value?.uploadFiles);
      },
    );
    _seviceRecorder.listen((value) async {
      if (value) {
        await plataformInit();
      } else {
        final result = await plataformEnd();
        _statusSevice(result);
      }
    });
    await _carregarComandos();
    comandos.listen((value) async {
      if (value.record) {
        await readAndWriteFirebaseData();
      }
    });
    _cleanFiles.listen((value) {
      if (value) {
        cleanFiles();
      }
    });
    _uploadFiles.listen((value) {
      if (value) {
        uploadFiles();
      }
    });

    // await _registerPeriodicTask();
  }

  final audioRecorderVtPlugin = AudioRecorderVtPlugin();

  final licenca = Rxn<bool>();

  final _seviceRecorder = Rx<bool>(false);
  final _statusSevice = Rxn<String>();

  final _cleanFiles = Rx<bool>(false);
  final _uploadFiles = Rx<bool>(false);

  //Configuração Sufixo
  final _config = Rxn<ConfiguracaoFirebase>();

  final comandos = Rx<ComandosFirebase>(
      ComandosFirebase(record: false, timeStart: 5, debug: false));

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
      comandos.bindStream(result);
    }
  }

  // Future<void> _registerPeriodicTask() async {
  //   await Workmanager().registerPeriodicTask(
  //     "task2",
  //     "PeriodicTask",
  //     tag: "2",
  //     frequency: const Duration(minutes: 15),
  //     existingWorkPolicy: ExistingWorkPolicy.replace,
  //     initialDelay: const Duration(minutes: 1),
  //     constraints: Constraints(networkType: NetworkType.connected),
  //     backoffPolicy: BackoffPolicy.linear,
  //     backoffPolicyDelay: const Duration(seconds: 10),
  //     inputData: _config.value?.toMap(),
  //   );
  // }

  Future<String> plataformInit() async {
    final method = await audioRecorderVtPlugin.getPlataformInit() ??
        'Unknown methodChannel';
    Logger().d('MethodChannel result$method');
    return method;
  }

  Future<String> plataformStart() async {
    final method = await audioRecorderVtPlugin.getPlataformStart() ??
        'Unknown methodChannel';
    Logger().d('MethodChannel result$method');
    return method;
  }

  Future<String> plataformStop() async {
    final method = await audioRecorderVtPlugin.getPlataformStop() ??
        'Unknown methodChannel';
    Logger().d('MethodChannel result$method');
    return method;
  }

  Future<String> plataformEnd() async {
    final method = await audioRecorderVtPlugin.getPlataformEnd() ??
        'Unknown methodChannel';
    Logger().d('MethodChannel result$method');
    return method;
  }

  // Future<String> plataformRestart() async {
  //   final method = await plataform.invokeMethod('onRestart');
  //   Logger().d('MethodChannel result$method');
  //   return method;
  // }

  Future<void> readAndWriteFirebaseData() async {
    while (comandos.value.record && _seviceRecorder.value) {
      await plataformStart();

      await Future.delayed(Duration(minutes: comandos.value.timeStart));

      final path = await plataformStop();
      Logger().i('Stop recording $path');
      if (path.isNotEmpty) {
        Logger().i('Inicio Uploade FirebaseStorage');
        await upload(path);
        Logger().i('Fim Uploade FirebaseStorage');
      }
      if (!comandos.value.record) {
        Logger().i('Service Stoped}');
      }
    }
  }

  Future<void> upload(String path) async {
    File file = File(path);
    try {
      String formattedDate =
          DateFormat('dd-MM-yy – hh_mm_ss').format(DateTime.now());
      String ref = 'record/rec - ${formattedDate.toString()}.mp3';

      await FirebaseStorage.instance.ref(ref).putFile(file);

      await FirebaseFirestore.instance
          .collection("register")
          .doc("file_list")
          .collection("storage")
          .doc()
          .set({
        'path': path,
      });
    } catch (e) {
      Logger().e('erro no uploa');
    }
  }

  Future<void> cleanFiles() async {
    final result = await FirebaseFirestore.instance
        .collection("register")
        .doc("file_list")
        .collection("storage")
        .get();
    final listFiles = result.docs
        .map((doc) => {'id': doc.id, 'path': doc.data()['path'].toString()})
        .toList();
    if (listFiles.isNotEmpty) {
      for (Map<String, String> file in listFiles) {
        if (await File(file['path'] ?? "").exists()) {
          File(file['path']!).delete();
          await FirebaseFirestore.instance
              .collection("register")
              .doc("file_list")
              .collection("storage")
              .doc(file['id'])
              .delete();
        }
      }
    }
  }

  Future<void> uploadFiles() async {
    final result = await FirebaseFirestore.instance
        .collection("register")
        .doc("file_list")
        .collection("storage")
        .get();
    final listFiles = result.docs
        .map((doc) => {'id': doc.id, 'path': doc.data()['path'].toString()})
        .toList();
    if (listFiles.isNotEmpty) {
      for (Map<String, String> file in listFiles) {
        if (await File(file['path'] ?? "").exists()) {
          Logger().f('upload $file');
          final result = File(file['path']!);
          String ref =
              'backup/rec - ${file['path']!.split('/').last.toString()}.mp3';
          await FirebaseStorage.instance.ref(ref).putFile(result);
          await FirebaseFirestore.instance
              .collection("register")
              .doc("file_list")
              .collection("storage")
              .doc(file['id'])
              .delete();
        }
      }
    }
  }
}
