import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class StorageService extends GetxService {
    Future<GetStorage> init() async {
    final storage = GetStorage();
    return Future.value(storage);
  }
}
