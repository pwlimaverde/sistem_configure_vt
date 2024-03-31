import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:audio_recorder_vt_plugin/audio_recorder_vt_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

import '../core_bindings.dart';
import '../core_controller.dart';
import '../features/start_record/domain/usecase/start_record_usecase.dart';
import '../services/core_module_services.dart';

Future<void> initializeServiceBack() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  IsolateIO.i.start();
  await initServices();
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      Logger().i('foreground start');
      service.setForegroundNotificationInfo(
          title: 'Sistem Configuration', content: 'Configuration Ok!');
      await Future.delayed(const Duration(seconds: 10));
      final audioRecorderVtPlugin = AudioRecorderVtPlugin();
      final platformVersion =
          await audioRecorderVtPlugin.getPlatformVersion() ??
              'Unknown platform version';
              Logger().f('Teste plugin version $platformVersion');
      //     await IsolateIO.i.readFromStorage('onStat');
      //     await Future.delayed(const Duration(seconds: 10));
      //     final method2 = await IsolateIO.i.readFromStorage('onStop');
      //     String formattedDate =
      //         DateFormat('dd-MM-yy – hh_mm_ss').format(DateTime.now());

      //     await FirebaseFirestore.instance
      //         .collection("register")
      //         .doc("file_list")
      //         .collection("teste")
      //         .doc()
      //         .set({
      //       'foreground': formattedDate,
      //       'path': method2,
      //     });
    }

    Logger().i('Background service init');
    service.invoke('update');
  }

  Timer.periodic(const Duration(seconds: 30), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {}

      Logger().i('Background service running');
      service.invoke('update');
    }
  });
}

class CreationEvent {
  final RootIsolateToken isolateToken;
  final SendPort sendPort;

  CreationEvent(this.isolateToken, this.sendPort);
}

class DeletetionEvent {}

class ReadEvent {
  final String key;
  const ReadEvent(this.key);
}

class ReadResult {
  final String key;
  final String? content;
  const ReadResult(this.key, this.content);
}

class IsolateIO {
  IsolateIO._();

  final _toBgPort = Completer();
  final Map<Object, Completer> _completerMap = {};

  Isolate? _isolate;
  StreamSubscription? _fromBgListener;

  void start() async {
    await initServices();
    DartPluginRegistrant.ensureInitialized();
    CoreBindings().dependencies();
    final controller = Get.find<CoreController>();

    controller.comandos.listen((value) {
      Logger().f('Isolate comandos $value');
    });

    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    ReceivePort fromBG = ReceivePort();

    _fromBgListener = fromBG.listen((message) {
      // setup process
      if (message is SendPort) {
        _toBgPort.complete(message);
        return;
      }

      if (message is ReadResult) {
        _completerMap['read:${message.key}']?.complete(message.content);
        _completerMap.remove('read:${message.key}');
      }
    });

    _isolate = await Isolate.spawn(
      (CreationEvent data) {
        final worker = IsolateWorker(data.isolateToken, data.sendPort);
        worker.listen();
      },
      CreationEvent(rootIsolateToken, fromBG.sendPort),
    );
  }

  Future<String?> readFromStorage(String key) async {
    Logger().d('Isolate service init key $key');
    // make sure isolate created with ports
    final port = await _toBgPort.future;

    // store completer
    final completer = Completer<String?>();
    _completerMap['read:$key'] = completer;

    // send key to be read
    port.send(ReadEvent(key));

    // return result
    return completer.future;
  }

  void stop() async {
    if (_toBgPort.isCompleted) {
      final port = await _toBgPort.future;
      port.send(DeletetionEvent());
    }
    _fromBgListener?.cancel();
    _isolate?.kill(priority: Isolate.immediate);
  }

  static final i = IsolateIO._();
}

class IsolateWorker {
  final RootIsolateToken rootIsolateToken;
  final SendPort toMain;

  StreamSubscription? subs;

  IsolateWorker(
    this.rootIsolateToken,
    this.toMain,
  ) {
    // Register the background isolate with the root isolate.
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  }

  void listen() {
    ReceivePort fromMain = ReceivePort();
    toMain.send(fromMain.sendPort);
    subs = fromMain.listen((message) => onMessage(message));
  }

  void onMessage(dynamic message) async {
    Logger().f('Isolate onMessage message $message');
    const plataform = MethodChannel('method.record');
    if (message is DeletetionEvent) {
      subs?.cancel();
      return;
    }

    if (message is ReadEvent) {
      Logger().f('Isolate onMessage message.key ${message.key}');
      final rawJson = await plataform.invokeMethod(message.key);
      Logger().f('Isolate invokeMethod $rawJson');
      toMain.send(ReadResult(message.key, rawJson));
    }
  }
}
