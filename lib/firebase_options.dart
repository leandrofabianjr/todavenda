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
        return windows;
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
    apiKey: 'AIzaSyBPvzNIp7LtRuNcxmFaGNLVZUhZhZceC1s',
    appId: '1:31100701763:web:1cf6bdb02eea3ae25d58f6',
    messagingSenderId: '31100701763',
    projectId: 'todavenda-prod',
    authDomain: 'todavenda-prod.firebaseapp.com',
    storageBucket: 'todavenda-prod.firebasestorage.app',
    measurementId: 'G-C5L0N8ENGH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBk76HDnJsvATD4ttE0N8ceylUwz_l1CaA',
    appId: '1:31100701763:android:896bb100e3da968a5d58f6',
    messagingSenderId: '31100701763',
    projectId: 'todavenda-prod',
    storageBucket: 'todavenda-prod.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJJOeCp6hVyNa2tgcYtemDFLFywhLCzyc',
    appId: '1:31100701763:ios:49361b66178ec7235d58f6',
    messagingSenderId: '31100701763',
    projectId: 'todavenda-prod',
    storageBucket: 'todavenda-prod.firebasestorage.app',
    androidClientId:
        '31100701763-e58usf29gbkv5055k0a5icbhpt3v9cnl.apps.googleusercontent.com',
    iosClientId:
        '31100701763-ic5vi9qb8fa0dqqi8e7mffr4iakt9cl7.apps.googleusercontent.com',
    iosBundleId: 'com.leandrofabianjr.todaavenda',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBJJOeCp6hVyNa2tgcYtemDFLFywhLCzyc',
    appId: '1:31100701763:ios:49361b66178ec7235d58f6',
    messagingSenderId: '31100701763',
    projectId: 'todavenda-prod',
    storageBucket: 'todavenda-prod.firebasestorage.app',
    androidClientId:
        '31100701763-e58usf29gbkv5055k0a5icbhpt3v9cnl.apps.googleusercontent.com',
    iosClientId:
        '31100701763-ic5vi9qb8fa0dqqi8e7mffr4iakt9cl7.apps.googleusercontent.com',
    iosBundleId: 'com.leandrofabianjr.todaavenda',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBPvzNIp7LtRuNcxmFaGNLVZUhZhZceC1s',
    appId: '1:31100701763:web:40bf4e5de461273a5d58f6',
    messagingSenderId: '31100701763',
    projectId: 'todavenda-prod',
    authDomain: 'todavenda-prod.firebaseapp.com',
    storageBucket: 'todavenda-prod.firebasestorage.app',
    measurementId: 'G-SKN4LH9WME',
  );
}
