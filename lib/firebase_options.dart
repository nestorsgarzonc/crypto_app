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
    apiKey: 'AIzaSyDADZH0BLG_fkV9PJsIvVyEVTbAoiWeReY',
    appId: '1:658102564288:web:7a24c6743d17888a614425',
    messagingSenderId: '658102564288',
    projectId: 'unlearn-148a3',
    authDomain: 'unlearn-148a3.firebaseapp.com',
    databaseURL: 'https://unlearn-148a3.firebaseio.com',
    storageBucket: 'unlearn-148a3.appspot.com',
    measurementId: 'G-843QJW4VYC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCgZrQnRX9RIlF3w7mjfJSwNasiIrDRvls',
    appId: '1:658102564288:android:4a21a3f2708b0496614425',
    messagingSenderId: '658102564288',
    projectId: 'unlearn-148a3',
    databaseURL: 'https://unlearn-148a3.firebaseio.com',
    storageBucket: 'unlearn-148a3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1zdPSpM9tnBvTNprAPdvzGbOB7IiMXp0',
    appId: '1:658102564288:ios:93adce48a882c8ab614425',
    messagingSenderId: '658102564288',
    projectId: 'unlearn-148a3',
    databaseURL: 'https://unlearn-148a3.firebaseio.com',
    storageBucket: 'unlearn-148a3.appspot.com',
    iosClientId: '658102564288-q6oi4s9ouej4ovrkhakqv98i2c61pgdm.apps.googleusercontent.com',
    iosBundleId: 'com.nestorsgarzonc.cryptoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD1zdPSpM9tnBvTNprAPdvzGbOB7IiMXp0',
    appId: '1:658102564288:ios:93adce48a882c8ab614425',
    messagingSenderId: '658102564288',
    projectId: 'unlearn-148a3',
    databaseURL: 'https://unlearn-148a3.firebaseio.com',
    storageBucket: 'unlearn-148a3.appspot.com',
    iosClientId: '658102564288-q6oi4s9ouej4ovrkhakqv98i2c61pgdm.apps.googleusercontent.com',
    iosBundleId: 'com.nestorsgarzonc.cryptoApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDADZH0BLG_fkV9PJsIvVyEVTbAoiWeReY',
    appId: '1:658102564288:web:7ed4d873bfada86d614425',
    messagingSenderId: '658102564288',
    projectId: 'unlearn-148a3',
    authDomain: 'unlearn-148a3.firebaseapp.com',
    databaseURL: 'https://unlearn-148a3.firebaseio.com',
    storageBucket: 'unlearn-148a3.appspot.com',
    measurementId: 'G-99ZW06PE74',
  );
}