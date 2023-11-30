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
    apiKey: 'AIzaSyBMR1HjngeET64TYfPP8L-dZ4MkAK9tgqI',
    appId: '1:1064457404415:web:02b6714b4cdc50041fb1ca',
    messagingSenderId: '1064457404415',
    projectId: 'smart-store1',
    authDomain: 'smart-store1.firebaseapp.com',
    storageBucket: 'smart-store1.appspot.com',
    measurementId: 'G-YW304XEKW7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSy6wj3EtV221djjvTISF1Y9CoDEu4cgI',
    appId: '1:1064457404415:android:2240fc93e70900fd1fb1ca',
    messagingSenderId: '1064457404415',
    projectId: 'smart-store1',
    storageBucket: 'smart-store1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBIJV80TtLAlH0SQK2478UoWJqybqevzyw',
    appId: '1:1064457404415:ios:c2b7d1a04bc64bf51fb1ca',
    messagingSenderId: '1064457404415',
    projectId: 'smart-store1',
    storageBucket: 'smart-store1.appspot.com',
    iosBundleId: 'com.example.storeApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBIJV80TtLAlH0SQK2478UoWJqybqevzyw',
    appId: '1:1064457404415:ios:8f1e0ad22799ed661fb1ca',
    messagingSenderId: '1064457404415',
    projectId: 'smart-store1',
    storageBucket: 'smart-store1.appspot.com',
    iosBundleId: 'com.example.storeApp.RunnerTests',
  );
}
