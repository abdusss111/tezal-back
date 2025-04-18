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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'API_KEY',
    appId: '1:622519178550:web:4ae3a1b627ca333c100f97',
    messagingSenderId: '622519178550',
    projectId: 'eqshare-4cee7',
    authDomain: 'eqshare-4cee7.firebaseapp.com',
    storageBucket: 'eqshare-4cee7.appspot.com',
    measurementId: 'G-03C74RT2XM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'API_KEY',
    appId: '1:622519178550:android:d7b5621e514484fc100f97',
    messagingSenderId: '622519178550',
    projectId: 'eqshare-4cee7',
    storageBucket: 'eqshare-4cee7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'API_KEY',
    appId: '1:622519178550:ios:a82d4fc962f81c08100f97',
    messagingSenderId: '622519178550',
    projectId: 'eqshare-4cee7',
    storageBucket: 'eqshare-4cee7.appspot.com',
    iosClientId: '622519178550-ecbvivef8e46selamduid8shb6f9cvoe.apps.googleusercontent.com',
    iosBundleId: 'com.mezet-online.mezet.kz',
  );

}