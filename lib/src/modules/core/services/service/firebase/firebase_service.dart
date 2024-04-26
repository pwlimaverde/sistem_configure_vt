
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

import 'options/firebase_options.dart';

class FirebaseService extends GetxService {
  Future<Unit> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return Future.value(unit);
  }
}
