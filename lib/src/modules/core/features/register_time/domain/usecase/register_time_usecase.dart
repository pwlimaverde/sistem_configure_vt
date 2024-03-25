import 'package:return_success_or_error/return_success_or_error.dart';

final class RegisterTimeUsecase
    extends UsecaseBaseCallData<Stream<List<Map<String, dynamic>>>,Stream<List<Map<String, dynamic>>>> {
  RegisterTimeUsecase(super.datasource);
  
  @override
  Future<ReturnSuccessOrError<Stream<List<Map<String, dynamic>>>>> call(ParametersReturnResult parameters) async{

    final resultDatacource = await resultDatasource(
      parameters: parameters,
      datasource: datasource,
    );

    return resultDatacource;
  }


}
