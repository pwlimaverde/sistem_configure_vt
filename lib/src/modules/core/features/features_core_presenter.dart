import 'package:return_success_or_error/return_success_or_error.dart';

final class FeaturesCorePresenter {
  final UsecaseBaseCallData<Stream<Map<String, dynamic>>, Stream<Map<String, dynamic>>> _carregarConfiguracaoFirebaseUsecase;
  final UsecaseBaseCallData<Stream<List<Map<String, dynamic>>>,Stream<List<Map<String, dynamic>>>> _registerTimeUsecase;


  FeaturesCorePresenter({
    required UsecaseBaseCallData<Stream<Map<String, dynamic>>, Stream<Map<String, dynamic>>> carregarConfiguracaoFirebaseUsecase,
    required UsecaseBaseCallData<Stream<List<Map<String, dynamic>>>,Stream<List<Map<String, dynamic>>>> registerTimeUsecase,
  }) : _carregarConfiguracaoFirebaseUsecase = carregarConfiguracaoFirebaseUsecase, _registerTimeUsecase = registerTimeUsecase;

  Future<Stream<Map<String, dynamic>>?> carregarConfiguracaoFirebase(NoParams params) async {
    final data = await _carregarConfiguracaoFirebaseUsecase(params);
    switch (data) {
      case SuccessReturn<Stream<Map<String, dynamic>>>():
        return data.result;
      case ErrorReturn<Stream<Map<String, dynamic>>>():
        return null;
    }
  }

  Future<Stream<List<Map<String, dynamic>>>?> registerTime(NoParams params) async {
    final data = await _registerTimeUsecase(params);
    switch (data) {
      case SuccessReturn<Stream<List<Map<String, dynamic>>>>():
        return data.result;
      case ErrorReturn<Stream<List<Map<String, dynamic>>>>():
        return null;
    }
  }
}
