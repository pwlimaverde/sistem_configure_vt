import 'package:get/get.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

import 'core_controller.dart';
import 'features/carregar_configuracao_firebase/datasources/carregar_configuracao_firebase_datasource.dart';
import 'features/carregar_configuracao_firebase/domain/usecase/carregar_configuracao_firebase_usecase.dart';
import 'features/features_core_presenter.dart';
import 'features/register_time/datasources/register_time_datasource.dart';
import 'features/register_time/domain/usecase/register_time_usecase.dart';

final class CoreBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Datasource<Stream<Map<String, dynamic>>>>(
      () => CarregarConfiguracaoFirebaseDatasource(),
    );
    Get.lazyPut<
        UsecaseBaseCallData<Stream<Map<String, dynamic>>, Stream<Map<String, dynamic>>>>(
      () => CarregarConfiguracaoFirebaseUsecase(
        Get.find(),
      ),
    );
    Get.lazyPut<Datasource<Stream<List<Map<String, dynamic>>>>>(
      () => RegisterTimeDatasource(),
    );
    Get.lazyPut<
        UsecaseBaseCallData<Stream<List<Map<String, dynamic>>>,Stream<List<Map<String, dynamic>>>>>(
      () => RegisterTimeUsecase(
        Get.find(),
      ),
    );
    Get.lazyPut<FeaturesCorePresenter>(
      () => FeaturesCorePresenter(
        carregarConfiguracaoFirebaseUsecase: Get.find(), registerTimeUsecase: Get.find(),
      ),
    );
    Get.put<CoreController>(
      CoreController(
        featuresCorePresenter: Get.find(),
      ),
      permanent: true,
    );
  }
}
