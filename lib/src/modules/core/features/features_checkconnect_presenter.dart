import 'package:return_success_or_error/return_success_or_error.dart';

final class FeaturesCheckconnectPresenter {
  final UsecaseBase<int> _twoPlusTowUsecase;

  FeaturesCheckconnectPresenter({
    required UsecaseBase<int> twoPlusTowUsecase,
  }) : _twoPlusTowUsecase = twoPlusTowUsecase;

  Future<int?> twoPlusTow(NoParams params) async {
    final data = await _twoPlusTowUsecase(params);
    switch (data) {
      case SuccessReturn<int>():
        return data.result;
      case ErrorReturn<int>():
        return 0;
    }
  }
}
