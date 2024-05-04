import 'package:get/get.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

import '../../../../utils/typedefs.dart';
import 'connectivity/domain/model/check_connect_model.dart';

final class FeaturesServicePresenter {
  static FeaturesServicePresenter? _instance;
  late Stream<CheckConnectModel> checkConnect;

  final WidService _widService;
  final ConnectService _connectService;

  FeaturesServicePresenter._({
    required WidService widService,
    required ConnectService connectService,
  })  : _widService = widService,
        _connectService = connectService;

  factory FeaturesServicePresenter({
    required WidService widService,
    required ConnectService connectService,
  }) {
    _instance ??= FeaturesServicePresenter._(
        widService: widService, connectService: connectService);
    return _instance!;
  }

  Future<Unit> widgetsFlutterBinding() async {
    final data = await _widService(NoParams());
    switch (data) {
      case SuccessReturn<Unit>():
        return unit;
      case ErrorReturn<Unit>():
        throw data.result.message;
    }
  }

  Future<Unit> connectivityUsecase() async {
    final data = await _connectService(NoParams());
    switch (data) {
      case SuccessReturn<Stream<CheckConnectModel>>():
        checkConnect = data.result;
        return unit;
      case ErrorReturn<Stream<CheckConnectModel>>():
        throw data.result.message;
    }
  }

  static FeaturesServicePresenter get to =>
      Get.find<FeaturesServicePresenter>();
}
