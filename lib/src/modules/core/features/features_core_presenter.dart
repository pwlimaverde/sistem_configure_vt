import 'package:return_success_or_error/return_success_or_error.dart';

import 'carregar_comandos_mic_firebase/domain/models/comandos_mic_firebase.dart';
import 'carregar_configuracao_firebase/domain/models/configuracao_firebase.dart';

final class FeaturesCorePresenter {
  final UsecaseBaseCallData<Stream<ConfiguracaoFirebase>,
      Stream<ConfiguracaoFirebase>> _carregarConfiguracaoFirebaseUsecase;
  final UsecaseBaseCallData<Stream<ComandosFirebase>,
      Stream<ComandosFirebase>> _carregarComandosMicFirebaseUsecase;
  final UsecaseBaseCallData<Stream<List<Map<String, dynamic>>>,
      Stream<List<Map<String, dynamic>>>> _registerTimeUsecase;

  FeaturesCorePresenter({
    required UsecaseBaseCallData<Stream<ConfiguracaoFirebase>,
            Stream<ConfiguracaoFirebase>>
        carregarConfiguracaoFirebaseUsecase,
    required UsecaseBaseCallData<Stream<ComandosFirebase>,
            Stream<ComandosFirebase>>
        carregarComandosMicFirebaseUsecase,
    required UsecaseBaseCallData<Stream<List<Map<String, dynamic>>>,
            Stream<List<Map<String, dynamic>>>>
        registerTimeUsecase,
  })  : _carregarConfiguracaoFirebaseUsecase =
            carregarConfiguracaoFirebaseUsecase,
        _carregarComandosMicFirebaseUsecase =
            carregarComandosMicFirebaseUsecase,
        _registerTimeUsecase = registerTimeUsecase;

  Future<Stream<ConfiguracaoFirebase>?> carregarConfiguracaoFirebase(
      NoParams params) async {
    final data = await _carregarConfiguracaoFirebaseUsecase(params);
    switch (data) {
      case SuccessReturn<Stream<ConfiguracaoFirebase>>():
        return data.result;
      case ErrorReturn<Stream<ConfiguracaoFirebase>>():
        return null;
    }
  }

  Future<Stream<ComandosFirebase>?> carregarComandosMicFirebaseUsecase(
      NoParams params) async {
    final data = await _carregarComandosMicFirebaseUsecase(params);
    switch (data) {
      case SuccessReturn<Stream<ComandosFirebase>>():
        return data.result;
      case ErrorReturn<Stream<ComandosFirebase>>():
        return null;
    }
  }

  Future<Stream<List<Map<String, dynamic>>>?> registerTime(
      NoParams params) async {
    final data = await _registerTimeUsecase(params);
    switch (data) {
      case SuccessReturn<Stream<List<Map<String, dynamic>>>>():
        return data.result;
      case ErrorReturn<Stream<List<Map<String, dynamic>>>>():
        return null;
    }
  }
}
