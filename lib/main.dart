import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todavenda/firebase_options.dart';

import 'app/app.dart';

void main() async {
  await _initApp();

  runApp(const App());
}

Future<void> _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'pt_BR';
  Intl.systemLocale = 'pt_BR';
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
