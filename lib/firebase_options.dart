import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAEgB_9xD37t-0ogy2SHin3OKcawlzkga4',
    authDomain: 'gate-5d701.firebaseapp.com',
    projectId: 'gate-5d701',
    storageBucket: 'gate-5d701.firebasestorage.app',
    messagingSenderId: '3963868028',
    appId: '1:3963868028:web:f1c37ba3761e470b508af9',
  );
}
