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
    apiKey: 'AIzaSyDMV1IIYFS5zPBRRnt96HO99GODIPKqqfA',
    appId: '1:51001186597:web:570bebce9903871a17e2cc',
    messagingSenderId: '51001186597',
    projectId: 'tahricha-app',
    authDomain: 'tahricha-app.firebaseapp.com',
    storageBucket: 'tahricha-app.appspot.com',
    measurementId: 'G-QJWF2GZD5X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDiBBZ8Uq5ZGiBIA_EhZQEPYam8GwORRAk',
    appId: '1:51001186597:android:9496c8c60f41a46c17e2cc',
    messagingSenderId: '51001186597',
    projectId: 'tahricha-app',
    storageBucket: 'tahricha-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCv8Enwu2l5y2QmHMgQ3LkM7y6I6yD_3Y8',
    appId: '1:51001186597:ios:ccc3bc3dafa63a1a17e2cc',
    messagingSenderId: '51001186597',
    projectId: 'tahricha-app',
    storageBucket: 'tahricha-app.appspot.com',
    iosClientId:
        '51001186597-pfd177uheg1e7b7oa7l3l0hsdrvhn4ud.apps.googleusercontent.com',
    iosBundleId: 'com.example.taharichaAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCv8Enwu2l5y2QmHMgQ3LkM7y6I6yD_3Y8',
    appId: '1:51001186597:ios:ccc3bc3dafa63a1a17e2cc',
    messagingSenderId: '51001186597',
    projectId: 'tahricha-app',
    storageBucket: 'tahricha-app.appspot.com',
    iosClientId:
        '51001186597-pfd177uheg1e7b7oa7l3l0hsdrvhn4ud.apps.googleusercontent.com',
    iosBundleId: 'com.example.taharichaAdmin',
  );
}