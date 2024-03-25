

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

final class CarregarConfiguracaoFirebaseDatasource
    implements Datasource<Stream<Map<String, dynamic>>> {
      @override
      Future<Stream<Map<String, dynamic>>> call(ParametersReturnResult parameters) async{
     try {
      final reference = FirebaseFirestore.instance
          .collection("configuracao")
          .doc("options");
      final configuracao = reference.snapshots();
   
        return configuracao.map((event) => event.data()!);

    } catch (e) {
      throw Exception("Erro ao carregar configurações do banco de dados");
    }
      }


}
