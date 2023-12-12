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
    apiKey: 'AIzaSyAwunpm2pyOFIqMdwYV7pSZc8I9SFqiUoA',
    appId: '1:1069743090321:web:f541e6c50ef93070c06d30',
    messagingSenderId: '1069743090321',
    projectId: 'planeador-eventos-ittepic',
    authDomain: 'planeador-eventos-ittepic.firebaseapp.com',
    storageBucket: 'planeador-eventos-ittepic.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANFdiOc_pHqblqZ7WTnl5zgscyungvF2c',
    appId: '1:1069743090321:android:3e0e5919375ec178c06d30',
    messagingSenderId: '1069743090321',
    projectId: 'planeador-eventos-ittepic',
    storageBucket: 'planeador-eventos-ittepic.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA2V9L_s89aYeKHf1ZmXNwXdZhU8WEfoDI',
    appId: '1:1069743090321:ios:1f183ca45bdeaf02c06d30',
    messagingSenderId: '1069743090321',
    projectId: 'planeador-eventos-ittepic',
    storageBucket: 'planeador-eventos-ittepic.appspot.com',
    iosBundleId: 'mx.edu.iitepic.damGaleriaFotosEventos',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA2V9L_s89aYeKHf1ZmXNwXdZhU8WEfoDI',
    appId: '1:1069743090321:ios:1f183ca45bdeaf02c06d30',
    messagingSenderId: '1069743090321',
    projectId: 'planeador-eventos-ittepic',
    storageBucket: 'planeador-eventos-ittepic.appspot.com',
    iosBundleId: 'mx.edu.iitepic.damGaleriaFotosEventos',
  );
}