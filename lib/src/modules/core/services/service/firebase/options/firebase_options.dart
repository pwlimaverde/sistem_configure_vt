// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC2ZazCgGo43mKCx8XNJCPcs6w6lE-koBo',
    appId: '1:1006778520372:web:70e02bc5d14203099b4b61',
    messagingSenderId: '1006778520372',
    projectId: 'sistem-configure-vt',
    authDomain: 'sistem-configure-vt.firebaseapp.com',
    storageBucket: 'sistem-configure-vt.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCM7C4icXeE-fqMjc6hARntb5wONQ7-nhI',
    appId: '1:1006778520372:android:7a3b78b22d26b93d9b4b61',
    messagingSenderId: '1006778520372',
    projectId: 'sistem-configure-vt',
    storageBucket: 'sistem-configure-vt.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyABDBrxVez-qd6_2ynixdu5bsYbZB2j55M',
    appId: '1:1006778520372:ios:bc01e8e4d184dae49b4b61',
    messagingSenderId: '1006778520372',
    projectId: 'sistem-configure-vt',
    storageBucket: 'sistem-configure-vt.appspot.com',
    androidClientId: '1006778520372-nmalurpdjuc7alvjomcd2cnv9eer9rdb.apps.googleusercontent.com',
    iosClientId: '1006778520372-qvarsp0q60s3vu6ac801cjrpfnl9d8t9.apps.googleusercontent.com',
    iosBundleId: 'br.com.pwlimaverde.sistemConfigureVt',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyABDBrxVez-qd6_2ynixdu5bsYbZB2j55M',
    appId: '1:1006778520372:ios:c83b0e55beaed7379b4b61',
    messagingSenderId: '1006778520372',
    projectId: 'sistem-configure-vt',
    storageBucket: 'sistem-configure-vt.appspot.com',
    androidClientId: '1006778520372-nmalurpdjuc7alvjomcd2cnv9eer9rdb.apps.googleusercontent.com',
    iosClientId: '1006778520372-7lvd77lji7lpma4rmgndtshjcr3v3mbc.apps.googleusercontent.com',
    iosBundleId: 'br.com.pwlimaverde.sistemConfigureVt.RunnerTests',
  );
}
