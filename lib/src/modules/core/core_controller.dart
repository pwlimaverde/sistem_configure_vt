import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

import 'features/features_core_presenter.dart';

final class CoreController extends GetxController {
  final FeaturesCorePresenter featuresCorePresenter;

  CoreController({required this.featuresCorePresenter});

  @override
  void onInit() {
    super.onInit();
    _carregarConfiguracao();
    _carregarTimes();
    _config.listen((value) {
      if (value != null) {
        licenca(value['licenca']);
      }
    });
    _setTime();
  }

  final licenca = Rx<bool>(false);

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

  void _setTime() {
    licenca.listen((value) async {
      while (licenca.value) {
        final road = _config.value?['time_start']??600;
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
