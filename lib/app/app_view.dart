import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'router/app_router.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Toda Venda',
      theme: appTheme(),
      routerConfig: appRouterConfig,
    );
  }
}
