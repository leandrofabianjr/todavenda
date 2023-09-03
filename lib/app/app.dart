import 'package:flutter/material.dart';
import 'package:todavenda/app/app_dependencies.dart';
import 'package:todavenda/app/app_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return injectDependencies(child: const AppView());
  }
}
