import 'package:crypto_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_app/app.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// The entry point of the application.
///
/// This function initializes Firebase, Hive, and runs the `CryptoApp` widget.
/// It ensures that the Flutter bindings are initialized before running the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with the default options for the current platform.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Hive for Flutter.
  await Hive.initFlutter();
  // Run the app wrapped in a `ProviderScope`.
  runApp(const ProviderScope(child: CryptoApp()));
}
