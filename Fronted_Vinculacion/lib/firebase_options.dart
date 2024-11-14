// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyBU_zwF4UAporhQYuI9TWAs8w_KdHEfr9M',
    appId: '1:747869535942:web:6e396c41654d5fb8f0e1c7',
    messagingSenderId: '747869535942',
    projectId: 'vinculacion-110d4',
    authDomain: 'vinculacion-110d4.firebaseapp.com',
    storageBucket: 'vinculacion-110d4.firebasestorage.app',
    measurementId: 'G-TYNRTE6Q5R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdp6DqVpUTeMjllwWUWm2QUohoC_OW_L0',
    appId: '1:747869535942:android:33ee11970c860779f0e1c7',
    messagingSenderId: '747869535942',
    projectId: 'vinculacion-110d4',
    storageBucket: 'vinculacion-110d4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDU-e-zuEMPxCjDK2QUTKUZcXZZumSQPEY',
    appId: '1:747869535942:ios:22a66793bd016c58f0e1c7',
    messagingSenderId: '747869535942',
    projectId: 'vinculacion-110d4',
    storageBucket: 'vinculacion-110d4.firebasestorage.app',
    iosBundleId: 'com.example.asistenciaUpeu',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDU-e-zuEMPxCjDK2QUTKUZcXZZumSQPEY',
    appId: '1:747869535942:ios:22a66793bd016c58f0e1c7',
    messagingSenderId: '747869535942',
    projectId: 'vinculacion-110d4',
    storageBucket: 'vinculacion-110d4.firebasestorage.app',
    iosBundleId: 'com.example.asistenciaUpeu',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBU_zwF4UAporhQYuI9TWAs8w_KdHEfr9M',
    appId: '1:747869535942:web:63ff8154ee1a9952f0e1c7',
    messagingSenderId: '747869535942',
    projectId: 'vinculacion-110d4',
    authDomain: 'vinculacion-110d4.firebaseapp.com',
    storageBucket: 'vinculacion-110d4.firebasestorage.app',
    measurementId: 'G-T4MVM3TQ0J',
  );
}
