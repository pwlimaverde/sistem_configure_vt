
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'options/firebase_options.dart';

class FirebaseService extends GetxService {
  Future<FirebaseApp> init() async {
    final firebase = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return firebase;
  }
}
