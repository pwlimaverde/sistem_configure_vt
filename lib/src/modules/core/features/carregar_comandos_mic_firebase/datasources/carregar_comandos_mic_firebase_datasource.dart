

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

import '../domain/models/comandos_mic_firebase.dart';

final class CarregarComandosMicFirebaseDatasource
    implements Datasource<Stream<ComandosFirebase>> {
      @override
      Future<Stream<ComandosFirebase>> call(ParametersReturnResult parameters) async{
     try {
      final reference = FirebaseFirestore.instance
          .collection("comandos")
          .doc("mic");
      final configuracao = reference.snapshots();
   
        return configuracao.map((event) => ComandosFirebase.fromMap(event.data()!));

    } catch (e) {
      throw Exception("Erro ao carregar configurações do banco de dados");
    }
      }


}
