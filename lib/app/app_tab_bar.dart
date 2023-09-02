/// Baseado em https://medium.com/@antonio.tioypedro1234/flutter-go-router-the-essential-guide-349ef39ec5b3
///

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: navigationShell.currentIndex,
      length: 3,
      child: Scaffold(
        body: navigationShell,
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.point_of_sale),
                    if (navigationShell.currentIndex == 0) const Text('Vender')
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.fact_check),
                    if (navigationShell.currentIndex == 1)
                      const Text('Relatórios')
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.app_registration),
                    if (navigationShell.currentIndex == 2)
                      const Text('Cadastros')
                  ],
                ),
              )
            ],
            onTap: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
          ),
        ),
      ),
    );
  }
}
