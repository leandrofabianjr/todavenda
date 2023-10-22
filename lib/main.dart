import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todavenda/firebase_options.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';

void main() async {
  await _initApp();

  runApp(const App());
}

Future<void> _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'pt_BR';
  Intl.systemLocale = 'pt_BR';
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
