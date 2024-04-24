import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  //Controles Internos
  Future<void> signInGoogleLogin({
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = result.user;

      if (user != null) {
        final docRef =
            FirebaseFirestore.instance.collection("user").doc(user.uid);
        final doc = await docRef.get();

        if (!doc.exists) {
          final nome = user.displayName;
          final email = user.email;

          final newUser =
              FirebaseFirestore.instance.collection("user").doc(user.uid);

          newUser.collection("dados").doc("registro").set({
            'nome': nome,
            'email': email,
            'licenca': null,
            'stop_service': false,
          });

          newUser.collection("comandos").doc("mic").set({
            'record': false,
            'clean_files': false,
            'upload_files': false,
            'time_start': 10,
          });
        }
      }

      onSuccess();
    } catch (e) {
      onFail();
    }
  }
}
