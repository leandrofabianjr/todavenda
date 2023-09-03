import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todavenda/firebase_options.dart';

import 'app/app.dart';

void main() async {
  await _initApp();

  runApp(const App());
}

Future<void> _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
