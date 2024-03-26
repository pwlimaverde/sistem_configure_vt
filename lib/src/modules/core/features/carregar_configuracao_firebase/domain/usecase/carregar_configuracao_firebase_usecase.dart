import 'package:return_success_or_error/return_success_or_error.dart';

import '../models/configuracao_firebase.dart';

final class CarregarConfiguracaoFirebaseUsecase
    extends UsecaseBaseCallData<Stream<ConfiguracaoFirebase>, Stream<ConfiguracaoFirebase>> {
  CarregarConfiguracaoFirebaseUsecase(super.datasource);
  
  @override
  Future<ReturnSuccessOrError<Stream<ConfiguracaoFirebase>>> call(ParametersReturnResult parameters) async{

    final resultDatacource = await resultDatasource(
      parameters: parameters,
      datasource: datasource,
    );

    return resultDatacource;
  }


}
