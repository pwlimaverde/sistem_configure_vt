import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

final class RegisterTimeDatasource
    implements Datasource<Stream<List<Map<String, dynamic>>>> {
  @override
  Future<Stream<List<Map<String, dynamic>>>> call(
      ParametersReturnResult parameters) async {
    try {
      final reference = FirebaseFirestore.instance
          .collection("comandos")
          .doc("time")
          .collection("register")
          .snapshots();

      final times = reference.map((event) => event.docs.map((e) => e.data()).toList());


      return times;
    } catch (e) {
      throw Exception("Erro ao carregar configurações do banco de dados");
    }
  }
}
