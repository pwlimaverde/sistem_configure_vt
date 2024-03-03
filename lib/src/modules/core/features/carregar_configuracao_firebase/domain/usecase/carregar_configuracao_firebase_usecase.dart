import 'package:return_success_or_error/return_success_or_error.dart';

final class CarregarConfiguracaoFirebaseUsecase
    extends UsecaseBaseCallData<Stream<Map<String, dynamic>>, Stream<Map<String, dynamic>>> {
  CarregarConfiguracaoFirebaseUsecase(super.datasource);
  
  @override
  Future<ReturnSuccessOrError<Stream<Map<String, dynamic>>>> call(ParametersReturnResult parameters) async{

    final resultDatacource = await resultDatasource(
      parameters: parameters,
      datasource: datasource,
    );

    return resultDatacource;
  }


}
