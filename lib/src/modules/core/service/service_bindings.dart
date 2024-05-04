import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

import '../../../utils/typedefs.dart';
import 'feature/connectivity/datasource/connectivity_datasource.dart';
import 'feature/connectivity/domain/usecase/connectivity_usecase.dart';
import 'feature/features_service_presenter.dart';
import 'feature/widgets_flutter_binding/datasource/widgets_flutter_binding_datasource.dart';
import 'feature/widgets_flutter_binding/domain/usecase/widgets_flutter_binding_usecase.dart';

final class ServiceBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Connectivity>(
      () => Connectivity(),
    );
    Get.lazyPut<ConnectServiceData>(
      () => ConnectivityDatasource(
        Get.find(),
      ),
    );
    Get.lazyPut<ConnectService>(
      () => CheckConnectUsecase(
        Get.find(),
      ),
    );
    Get.lazyPut<WidServiceData>(
      () => WidgetsFlutterBindingDatasource(),
    );
    Get.lazyPut<WidService>(
      () => WidgetsFlutterBindingUsecase(
        Get.find(),
      ),
    );
    Get.put<FeaturesServicePresenter>(
      FeaturesServicePresenter(
        widService: Get.find(),
        connectService: Get.find(),
      ),
    );
  }
}