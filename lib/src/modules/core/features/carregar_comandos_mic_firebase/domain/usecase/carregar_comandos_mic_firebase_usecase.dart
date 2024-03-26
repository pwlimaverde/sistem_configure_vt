import 'package:return_success_or_error/return_success_or_error.dart';

import '../models/comandos_mic_firebase.dart';

final class CarregarComandosMicFirebaseUsecase
    extends UsecaseBaseCallData<Stream<ComandosFirebase>, Stream<ComandosFirebase>> {
  CarregarComandosMicFirebaseUsecase(super.datasource);
  
  @override
  Future<ReturnSuccessOrError<Stream<ComandosFirebase>>> call(ParametersReturnResult parameters) async{

    final resultDatacource = await resultDatasource(
      parameters: parameters,
      datasource: datasource,
    );

    return resultDatacource;
  }


}
